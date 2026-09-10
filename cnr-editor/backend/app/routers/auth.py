"""Login, MFA enrollment and current-session endpoints."""

from datetime import UTC, datetime, timedelta

from fastapi import APIRouter, Depends, HTTPException, Request, Response, status
from sqlalchemy import delete, select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.config import Settings, get_settings
from app.database import get_db
from app.dependencies import SessionContext, get_current_user, require_csrf
from app.models import (
    EditorLoginThrottle,
    EditorMfaChallenge,
    EditorMfaRecoveryCode,
    EditorSession,
    EditorTotpCredential,
    EditorUser,
    EditorUserRevision,
)
from app.schemas import (
    LoginRequest,
    MfaChallengeOut,
    MfaConfirmOut,
    MfaConfirmRequest,
    MfaDisableRequest,
    MfaSetupOut,
    MfaSetupRequest,
    MfaVerifyRequest,
    SessionOut,
    UserOut,
)
from app.security import (
    MfaConfigurationError,
    decrypt_totp_secret,
    dummy_password_hash,
    encrypt_totp_secret,
    hash_recovery_code,
    hash_secret,
    login_subject_hash,
    new_recovery_codes,
    new_secret,
    new_totp_secret,
    totp_provisioning_uri,
    totp_qr_svg_data_uri,
    verify_password,
    verify_totp_code,
)

router = APIRouter(prefix="/auth", tags=["authentication"])
LOGIN_FAILURE_THRESHOLD = 5
LOGIN_COOLDOWNS_SECONDS = (30, 60, 300, 900)
MFA_MAX_ATTEMPTS = 5


def set_auth_cookies(
    response: Response,
    settings: Settings,
    session_token: str,
    csrf_token: str,
) -> None:
    max_age = settings.session_ttl_hours * 3600
    response.set_cookie(
        settings.session_cookie_name,
        session_token,
        max_age=max_age,
        httponly=True,
        secure=settings.cookie_secure,
        samesite="strict",
        path="/api",
    )
    response.set_cookie(
        settings.csrf_cookie_name,
        csrf_token,
        max_age=max_age,
        httponly=False,
        secure=settings.cookie_secure,
        samesite="strict",
        path="/",
    )


def _set_mfa_challenge_cookie(
    response: Response,
    settings: Settings,
    challenge_token: str,
) -> None:
    response.set_cookie(
        settings.mfa_challenge_cookie_name,
        challenge_token,
        max_age=settings.mfa_challenge_ttl_minutes * 60,
        httponly=True,
        secure=settings.cookie_secure,
        samesite="strict",
        path="/api/auth",
    )


def _delete_mfa_challenge_cookie(response: Response, settings: Settings) -> None:
    response.delete_cookie(settings.mfa_challenge_cookie_name, path="/api/auth")


def _mfa_encryption_key(settings: Settings) -> str | None:
    return (
        settings.mfa_encryption_key.get_secret_value()
        if settings.mfa_encryption_key is not None
        else None
    )


def _mfa_unavailable(exc: Exception) -> HTTPException:
    return HTTPException(
        status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
        detail="El segundo factor no está disponible; contacta con un administrador",
    )


def _create_session(
    db: Session,
    user: EditorUser,
    settings: Settings,
    now: datetime,
) -> tuple[str, str]:
    session_token = new_secret()
    csrf_token = new_secret()
    db.add(
        EditorSession(
            token_hash=hash_secret(session_token),
            csrf_token_hash=hash_secret(csrf_token),
            user_id=user.user_id,
            expires_at=now + timedelta(hours=settings.session_ttl_hours),
        )
    )
    return session_token, csrf_token


def _throttle_record(
    db: Session,
    username: str,
) -> EditorLoginThrottle | None:
    return db.scalar(
        select(EditorLoginThrottle)
        .where(EditorLoginThrottle.subject_hash == login_subject_hash(username))
        .with_for_update()
    )


def _raise_if_login_blocked(
    db: Session,
    username: str,
    now: datetime,
) -> None:
    record = _throttle_record(db, username)
    if record is None or record.blocked_until is None or record.blocked_until <= now:
        return
    retry_after = max(1, int((record.blocked_until - now).total_seconds()) + 1)
    raise HTTPException(
        status_code=status.HTTP_429_TOO_MANY_REQUESTS,
        detail="Demasiados intentos fallidos. Espera antes de volver a intentarlo",
        headers={"Retry-After": str(retry_after)},
    )


def _record_login_failure(
    db: Session,
    username: str,
    now: datetime,
    settings: Settings,
) -> int | None:
    record = _throttle_record(db, username)
    window = timedelta(minutes=settings.login_failure_window_minutes)
    if record is None:
        record = EditorLoginThrottle(
            subject_hash=login_subject_hash(username),
            failed_attempts=0,
            window_started_at=now,
        )
        db.add(record)
    elif record.window_started_at + window <= now:
        record.failed_attempts = 0
        record.window_started_at = now
        record.blocked_until = None

    record.failed_attempts += 1
    record.updated_at = now
    if record.failed_attempts < LOGIN_FAILURE_THRESHOLD:
        return None
    cooldown_index = min(
        record.failed_attempts - LOGIN_FAILURE_THRESHOLD,
        len(LOGIN_COOLDOWNS_SECONDS) - 1,
    )
    cooldown = LOGIN_COOLDOWNS_SECONDS[cooldown_index]
    record.blocked_until = now + timedelta(seconds=cooldown)
    return cooldown


def _clear_login_failures(db: Session, username: str) -> None:
    db.execute(
        delete(EditorLoginThrottle).where(
            EditorLoginThrottle.subject_hash == login_subject_hash(username)
        )
    )


def _commit_login_failure(
    db: Session,
    username: str,
    now: datetime,
    settings: Settings,
) -> int | None:
    """Persist a login failure, retrying a concurrent first-row insertion."""
    cooldown = _record_login_failure(db, username, now, settings)
    try:
        db.commit()
    except IntegrityError:
        db.rollback()
        cooldown = _record_login_failure(db, username, now, settings)
        db.commit()
    return cooldown


def _consume_mfa_code(
    db: Session,
    credential: EditorTotpCredential,
    code: str,
    settings: Settings,
    now: datetime,
) -> bool:
    try:
        secret = decrypt_totp_secret(
            credential.secret_ciphertext,
            _mfa_encryption_key(settings),
        )
    except MfaConfigurationError as exc:
        raise _mfa_unavailable(exc) from exc

    matching_step = verify_totp_code(secret, code, credential.last_used_step, now)
    if matching_step is not None:
        credential.last_used_step = matching_step
        return True

    recovery = db.scalar(
        select(EditorMfaRecoveryCode)
        .where(
            EditorMfaRecoveryCode.user_id == credential.user_id,
            EditorMfaRecoveryCode.code_hash == hash_recovery_code(code),
            EditorMfaRecoveryCode.used_at.is_(None),
        )
        .with_for_update()
    )
    if recovery is None:
        return False
    recovery.used_at = now
    return True


@router.post("/login", response_model=SessionOut | MfaChallengeOut)
def login(
    payload: LoginRequest,
    response: Response,
    db: Session = Depends(get_db),
    settings: Settings = Depends(get_settings),
) -> SessionOut | MfaChallengeOut:
    now = datetime.now(UTC).replace(tzinfo=None)
    _raise_if_login_blocked(db, payload.username, now)
    user = db.scalar(select(EditorUser).where(EditorUser.username == payload.username))
    encoded_hash = user.password_hash if user is not None else dummy_password_hash
    valid = verify_password(payload.password, encoded_hash)
    if user is None or not valid or not user.active:
        cooldown = _commit_login_failure(db, payload.username, now, settings)
        if cooldown is not None:
            raise HTTPException(
                status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                detail="Demasiados intentos fallidos. Espera antes de volver a intentarlo",
                headers={"Retry-After": str(cooldown)},
            )
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, detail="Credenciales no válidas"
        )

    db.execute(delete(EditorSession).where(EditorSession.expires_at <= now))
    db.execute(delete(EditorMfaChallenge).where(EditorMfaChallenge.expires_at <= now))

    if user.mfa_enabled:
        try:
            decrypt_totp_secret(
                user.totp_credential.secret_ciphertext,
                _mfa_encryption_key(settings),
            )
        except MfaConfigurationError as exc:
            raise _mfa_unavailable(exc) from exc
        db.execute(
            delete(EditorMfaChallenge).where(EditorMfaChallenge.user_id == user.user_id)
        )
        challenge_token = new_secret()
        db.add(
            EditorMfaChallenge(
                token_hash=hash_secret(challenge_token),
                user_id=user.user_id,
                expires_at=now + timedelta(minutes=settings.mfa_challenge_ttl_minutes),
            )
        )
        db.commit()
        _set_mfa_challenge_cookie(response, settings, challenge_token)
        return MfaChallengeOut()

    session_token, csrf_token = _create_session(db, user, settings, now)
    _clear_login_failures(db, user.username)
    db.commit()
    set_auth_cookies(response, settings, session_token, csrf_token)
    _delete_mfa_challenge_cookie(response, settings)
    return SessionOut(user=UserOut.model_validate(user), writes_enabled=settings.writes_enabled)


@router.post("/mfa/verify", response_model=SessionOut)
def verify_mfa(
    payload: MfaVerifyRequest,
    request: Request,
    response: Response,
    db: Session = Depends(get_db),
    settings: Settings = Depends(get_settings),
) -> SessionOut:
    challenge_token = request.cookies.get(settings.mfa_challenge_cookie_name)
    if not challenge_token:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="El desafío de segundo factor ha caducado",
        )
    challenge = db.scalar(
        select(EditorMfaChallenge)
        .where(EditorMfaChallenge.token_hash == hash_secret(challenge_token))
        .with_for_update()
    )
    now = datetime.now(UTC).replace(tzinfo=None)
    if (
        challenge is None
        or challenge.expires_at <= now
        or not challenge.user.active
        or not challenge.user.mfa_enabled
    ):
        if challenge is not None:
            db.delete(challenge)
            db.commit()
        _delete_mfa_challenge_cookie(response, settings)
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="El desafío de segundo factor ha caducado",
        )

    credential = db.scalar(
        select(EditorTotpCredential)
        .where(EditorTotpCredential.user_id == challenge.user_id)
        .with_for_update()
    )
    if credential is None or credential.confirmed_at is None:
        db.delete(challenge)
        db.commit()
        _delete_mfa_challenge_cookie(response, settings)
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="El desafío de segundo factor ha caducado",
        )

    if not _consume_mfa_code(
        db,
        credential,
        payload.code,
        settings,
        now,
    ):
        challenge.failed_attempts += 1
        attempts_left = MFA_MAX_ATTEMPTS - challenge.failed_attempts
        if attempts_left <= 0:
            db.delete(challenge)
            db.commit()
            _delete_mfa_challenge_cookie(response, settings)
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Demasiados códigos incorrectos; vuelve a iniciar sesión",
            )
        db.commit()
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Código no válido. Quedan {attempts_left} intentos",
        )

    user = challenge.user
    db.delete(challenge)
    session_token, csrf_token = _create_session(db, user, settings, now)
    _clear_login_failures(db, user.username)
    db.commit()
    set_auth_cookies(response, settings, session_token, csrf_token)
    _delete_mfa_challenge_cookie(response, settings)
    return SessionOut(user=UserOut.model_validate(user), writes_enabled=settings.writes_enabled)


@router.post("/mfa/setup", response_model=MfaSetupOut)
def setup_mfa(
    payload: MfaSetupRequest,
    context: SessionContext = Depends(require_csrf),
    db: Session = Depends(get_db),
    settings: Settings = Depends(get_settings),
) -> MfaSetupOut:
    user = context.user
    if not verify_password(payload.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="La contraseña no es correcta",
        )
    if user.mfa_enabled:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="El segundo factor ya está activado",
        )

    secret = new_totp_secret()
    try:
        ciphertext = encrypt_totp_secret(secret, _mfa_encryption_key(settings))
    except MfaConfigurationError as exc:
        raise _mfa_unavailable(exc) from exc
    credential = db.scalar(
        select(EditorTotpCredential)
        .where(EditorTotpCredential.user_id == user.user_id)
        .with_for_update()
    )
    if credential is None:
        credential = EditorTotpCredential(user_id=user.user_id, secret_ciphertext=ciphertext)
        db.add(credential)
    else:
        credential.secret_ciphertext = ciphertext
        credential.created_at = datetime.now(UTC).replace(tzinfo=None)
        credential.confirmed_at = None
        credential.last_used_step = None
        credential.recovery_codes.clear()
    db.commit()

    provisioning_uri = totp_provisioning_uri(secret, user.username, settings.mfa_issuer)
    return MfaSetupOut(
        secret=secret,
        provisioning_uri=provisioning_uri,
        qr_svg_data_uri=totp_qr_svg_data_uri(provisioning_uri),
    )


@router.post("/mfa/confirm", response_model=MfaConfirmOut)
def confirm_mfa(
    payload: MfaConfirmRequest,
    context: SessionContext = Depends(require_csrf),
    db: Session = Depends(get_db),
    settings: Settings = Depends(get_settings),
) -> MfaConfirmOut:
    user = context.user
    credential = db.scalar(
        select(EditorTotpCredential)
        .where(EditorTotpCredential.user_id == user.user_id)
        .with_for_update()
    )
    if credential is None or credential.confirmed_at is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="No hay una configuración pendiente de confirmar",
        )
    now = datetime.now(UTC).replace(tzinfo=None)
    try:
        secret = decrypt_totp_secret(
            credential.secret_ciphertext,
            _mfa_encryption_key(settings),
        )
    except MfaConfigurationError as exc:
        raise _mfa_unavailable(exc) from exc
    matching_step = verify_totp_code(secret, payload.code, None, now)
    if matching_step is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="El código de verificación no es válido",
        )

    recovery_codes = new_recovery_codes()
    credential.confirmed_at = now
    credential.last_used_step = matching_step
    credential.recovery_codes.extend(
        EditorMfaRecoveryCode(user_id=user.user_id, code_hash=hash_recovery_code(code))
        for code in recovery_codes
    )
    db.execute(
        delete(EditorSession).where(
            EditorSession.user_id == user.user_id,
            EditorSession.token_hash != context.session.token_hash,
        )
    )
    db.add(
        EditorUserRevision(
            target_user_id=user.user_id,
            actor_user_id=user.user_id,
            action="mfa_enable",
            before_json={"mfa_enabled": False},
            after_json={"mfa_enabled": True},
        )
    )
    db.commit()
    return MfaConfirmOut(recovery_codes=recovery_codes)


@router.post("/mfa/disable", status_code=status.HTTP_204_NO_CONTENT)
def disable_mfa(
    payload: MfaDisableRequest,
    response: Response,
    context: SessionContext = Depends(require_csrf),
    db: Session = Depends(get_db),
    settings: Settings = Depends(get_settings),
) -> None:
    user = context.user
    credential = db.scalar(
        select(EditorTotpCredential)
        .where(EditorTotpCredential.user_id == user.user_id)
        .with_for_update()
    )
    if credential is None or credential.confirmed_at is None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="El segundo factor no está activado",
        )
    if not verify_password(payload.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="La contraseña no es correcta",
        )
    now = datetime.now(UTC).replace(tzinfo=None)
    if not _consume_mfa_code(db, credential, payload.code, settings, now):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="El código de verificación no es válido",
        )

    db.add(
        EditorUserRevision(
            target_user_id=user.user_id,
            actor_user_id=user.user_id,
            action="mfa_disable",
            before_json={"mfa_enabled": True},
            after_json={"mfa_enabled": False},
        )
    )
    db.execute(delete(EditorSession).where(EditorSession.user_id == user.user_id))
    db.delete(credential)
    db.commit()
    response.delete_cookie(settings.session_cookie_name, path="/api")
    response.delete_cookie(settings.csrf_cookie_name, path="/")
    _delete_mfa_challenge_cookie(response, settings)


@router.get("/me", response_model=SessionOut)
def me(
    user: EditorUser = Depends(get_current_user),
    settings: Settings = Depends(get_settings),
) -> SessionOut:
    return SessionOut(user=UserOut.model_validate(user), writes_enabled=settings.writes_enabled)


@router.post("/logout", status_code=status.HTTP_204_NO_CONTENT)
def logout(
    response: Response,
    context: SessionContext = Depends(require_csrf),
    db: Session = Depends(get_db),
    settings: Settings = Depends(get_settings),
) -> None:
    db.delete(context.session)
    db.commit()
    response.delete_cookie(settings.session_cookie_name, path="/api")
    response.delete_cookie(settings.csrf_cookie_name, path="/")
    _delete_mfa_challenge_cookie(response, settings)
