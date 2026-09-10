"""Authentication tests for TOTP MFA and progressive account cooldowns."""

from datetime import UTC, datetime
from http.cookies import SimpleCookie

import pyotp
import pytest
from cryptography.fernet import Fernet
from fastapi import HTTPException, Request, Response
from sqlalchemy import create_engine, func, select
from sqlalchemy.orm import Session as DatabaseSession

from app.config import Settings
from app.models import (
    EditorLoginThrottle,
    EditorMfaChallenge,
    EditorMfaRecoveryCode,
    EditorProfessionPermission,
    EditorSession,
    EditorSystemPermission,
    EditorTotpCredential,
    EditorUser,
)
from app.routers.auth import login, verify_mfa
from app.schemas import LoginRequest, MfaChallengeOut, MfaVerifyRequest, SessionOut
from app.security import (
    decrypt_totp_secret,
    encrypt_totp_secret,
    hash_password,
    hash_recovery_code,
    new_recovery_codes,
    new_totp_secret,
    verify_totp_code,
)


def _auth_database() -> tuple[object, Settings, str]:
    engine = create_engine("sqlite+pysqlite:///:memory:")
    for table in (
        EditorUser.__table__,
        EditorProfessionPermission.__table__,
        EditorSystemPermission.__table__,
        EditorSession.__table__,
        EditorTotpCredential.__table__,
        EditorMfaRecoveryCode.__table__,
        EditorMfaChallenge.__table__,
        EditorLoginThrottle.__table__,
    ):
        table.create(engine)
    encryption_key = Fernet.generate_key().decode("ascii")
    settings = Settings(
        database_url="sqlite+pysqlite:///:memory:",
        mfa_encryption_key=encryption_key,
        cookie_secure=False,
    )
    return engine, settings, encryption_key


def _challenge_request(response: Response, cookie_name: str) -> Request:
    cookies = SimpleCookie()
    for header in response.headers.getlist("set-cookie"):
        cookies.load(header)
    token = cookies[cookie_name].value
    return Request(
        {
            "type": "http",
            "method": "POST",
            "path": "/api/auth/mfa/verify",
            "headers": [(b"cookie", f"{cookie_name}={token}".encode("ascii"))],
        }
    )


def test_totp_secret_is_encrypted_and_an_accepted_step_cannot_be_replayed() -> None:
    encryption_key = Fernet.generate_key().decode("ascii")
    secret = new_totp_secret()
    ciphertext = encrypt_totp_secret(secret, encryption_key)
    now = datetime(2026, 9, 2, 12, 0, tzinfo=UTC)
    code = pyotp.TOTP(secret).at(now)

    assert secret not in ciphertext
    assert decrypt_totp_secret(ciphertext, encryption_key) == secret
    accepted_step = verify_totp_code(secret, code, None, now)
    assert accepted_step is not None
    assert verify_totp_code(secret, code, accepted_step, now) is None


def test_recovery_codes_are_unique_and_normalized_before_hashing() -> None:
    codes = new_recovery_codes()

    assert len(codes) == 10
    assert len(set(codes)) == 10
    assert hash_recovery_code(codes[0]) == hash_recovery_code(
        codes[0].lower().replace("-", " ")
    )


def test_fifth_bad_password_starts_account_cooldown() -> None:
    engine, settings, _ = _auth_database()
    with DatabaseSession(engine) as db:
        db.add(
            EditorUser(
                username="cooldown-user",
                password_hash=hash_password("a-secure-cooldown-password"),
                role="editor",
                active=True,
            )
        )
        db.commit()

        statuses = []
        for _ in range(5):
            with pytest.raises(HTTPException) as raised:
                login(
                    LoginRequest(username="cooldown-user", password="wrong-password"),
                    Response(),
                    db,
                    settings,
                )
            statuses.append(raised.value.status_code)

        assert statuses == [401, 401, 401, 401, 429]
        throttle = db.scalar(select(EditorLoginThrottle))
        assert throttle is not None
        assert throttle.failed_attempts == 5
        assert throttle.blocked_until is not None


def test_mfa_password_challenge_does_not_create_a_session() -> None:
    engine, settings, encryption_key = _auth_database()
    secret = new_totp_secret()
    with DatabaseSession(engine) as db:
        user = EditorUser(
            username="mfa-user",
            password_hash=hash_password("a-secure-mfa-password"),
            role="editor",
            active=True,
        )
        db.add(user)
        db.flush()
        db.add(
            EditorTotpCredential(
                user_id=user.user_id,
                secret_ciphertext=encrypt_totp_secret(secret, encryption_key),
                confirmed_at=datetime.now(UTC).replace(tzinfo=None),
            )
        )
        db.commit()

        password_response = Response()
        result = login(
            LoginRequest(username="mfa-user", password="a-secure-mfa-password"),
            password_response,
            db,
            settings,
        )

        assert isinstance(result, MfaChallengeOut)
        assert db.scalar(select(func.count()).select_from(EditorSession)) == 0
        assert db.scalar(select(func.count()).select_from(EditorMfaChallenge)) == 1

        request = _challenge_request(password_response, settings.mfa_challenge_cookie_name)
        code = pyotp.TOTP(secret).now()
        verified = verify_mfa(
            MfaVerifyRequest(code=code),
            request,
            Response(),
            db,
            settings,
        )

        assert isinstance(verified, SessionOut)
        assert verified.user.username == "mfa-user"
        assert db.scalar(select(func.count()).select_from(EditorSession)) == 1
        assert db.scalar(select(func.count()).select_from(EditorMfaChallenge)) == 0


def test_fifth_bad_mfa_code_destroys_the_challenge() -> None:
    engine, settings, encryption_key = _auth_database()
    secret = new_totp_secret()
    with DatabaseSession(engine) as db:
        user = EditorUser(
            username="limited-mfa-user",
            password_hash=hash_password("a-secure-limited-mfa-password"),
            role="editor",
            active=True,
        )
        db.add(user)
        db.flush()
        db.add(
            EditorTotpCredential(
                user_id=user.user_id,
                secret_ciphertext=encrypt_totp_secret(secret, encryption_key),
                confirmed_at=datetime.now(UTC).replace(tzinfo=None),
            )
        )
        db.commit()

        password_response = Response()
        login(
            LoginRequest(
                username="limited-mfa-user",
                password="a-secure-limited-mfa-password",
            ),
            password_response,
            db,
            settings,
        )
        request = _challenge_request(password_response, settings.mfa_challenge_cookie_name)

        for _ in range(5):
            with pytest.raises(HTTPException) as raised:
                verify_mfa(
                    MfaVerifyRequest(code="WRONG-CODE"),
                    request,
                    Response(),
                    db,
                    settings,
                )
            assert raised.value.status_code == 401

        assert db.scalar(select(func.count()).select_from(EditorMfaChallenge)) == 0
        assert db.scalar(select(func.count()).select_from(EditorSession)) == 0


def test_recovery_code_can_create_only_one_session() -> None:
    engine, settings, encryption_key = _auth_database()
    secret = new_totp_secret()
    recovery_code = "ABCD-EFGH-JK23"
    with DatabaseSession(engine) as db:
        user = EditorUser(
            username="recovery-user",
            password_hash=hash_password("a-secure-recovery-password"),
            role="editor",
            active=True,
        )
        db.add(user)
        db.flush()
        credential = EditorTotpCredential(
            user_id=user.user_id,
            secret_ciphertext=encrypt_totp_secret(secret, encryption_key),
            confirmed_at=datetime.now(UTC).replace(tzinfo=None),
        )
        credential.recovery_codes.append(
            EditorMfaRecoveryCode(
                user_id=user.user_id,
                code_hash=hash_recovery_code(recovery_code),
            )
        )
        db.add(credential)
        db.commit()

        first_password_response = Response()
        login(
            LoginRequest(username="recovery-user", password="a-secure-recovery-password"),
            first_password_response,
            db,
            settings,
        )
        verify_mfa(
            MfaVerifyRequest(code=recovery_code),
            _challenge_request(
                first_password_response,
                settings.mfa_challenge_cookie_name,
            ),
            Response(),
            db,
            settings,
        )

        second_password_response = Response()
        login(
            LoginRequest(username="recovery-user", password="a-secure-recovery-password"),
            second_password_response,
            db,
            settings,
        )
        with pytest.raises(HTTPException) as raised:
            verify_mfa(
                MfaVerifyRequest(code=recovery_code),
                _challenge_request(
                    second_password_response,
                    settings.mfa_challenge_cookie_name,
                ),
                Response(),
                db,
                settings,
            )

        assert raised.value.status_code == 401
        assert db.scalar(select(func.count()).select_from(EditorSession)) == 1
