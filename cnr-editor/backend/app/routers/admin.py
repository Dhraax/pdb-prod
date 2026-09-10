"""Permission-controlled system-user management endpoints."""

from fastapi import APIRouter, Depends, HTTPException, Response, status
from sqlalchemy import delete, select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session, selectinload

from app.database import get_db
from app.dependencies import (
    SessionContext,
    require_csrf,
    require_user_manager,
    require_user_viewer,
)
from app.models import (
    EditorMfaChallenge,
    EditorProfessionPermission,
    EditorSession,
    EditorSystemPermission,
    EditorTotpCredential,
    EditorUser,
    EditorUserRevision,
    Profession,
)
from app.schemas import UserCreate, UserOut, UserUpdate
from app.security import hash_password

router = APIRouter(prefix="/admin/users", tags=["administration"])


def _user_snapshot(user: EditorUser) -> dict[str, object]:
    """Return an audit-safe user profile without authentication secrets."""
    return {
        "user_id": user.user_id,
        "username": user.username,
        "email": user.email,
        "role": user.role,
        "active": user.active,
        "editable_profession_ids": user.editable_profession_ids,
        "permissions": user.permissions,
        "mfa_enabled": user.mfa_enabled,
    }


def _set_profession_permissions(
    db: Session,
    user: EditorUser,
    profession_ids: list[int],
) -> None:
    requested = set(profession_ids)
    known = set(
        db.scalars(
            select(Profession.profession_id).where(Profession.profession_id.in_(requested))
        )
    )
    if requested != known:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail="Uno o más oficios asignados no existen",
        )

    user.profession_permissions.clear()
    user.profession_permissions.extend(
        EditorProfessionPermission(profession_id=profession_id)
        for profession_id in sorted(requested)
    )


def _require_system_permission_manager(
    actor: EditorUser,
    requested_permissions: list[str],
    current_permissions: list[str],
) -> None:
    """Prevent non-administrators from changing sensitive system permissions."""
    if actor.role != "admin" and set(requested_permissions) != set(current_permissions):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Solo un administrador puede cambiar permisos del sistema",
        )


def _set_system_permissions(user: EditorUser, permission_names: list[str]) -> None:
    """Replace explicit system capabilities with the validated requested set."""
    requested = set(permission_names)
    user.system_permissions[:] = [
        permission
        for permission in user.system_permissions
        if permission.permission_name in requested
    ]
    existing = {permission.permission_name for permission in user.system_permissions}
    user.system_permissions.extend(
        EditorSystemPermission(permission_name=permission_name)
        for permission_name in sorted(requested - existing)
    )


def _require_admin_profile_manager(
    actor: EditorUser,
    current_role: str | None,
    requested_role: str | None,
) -> None:
    """Prevent user editors from crossing the administrator trust boundary."""
    if actor.role != "admin" and (
        current_role == "admin" or requested_role == "admin"
    ):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Solo un administrador puede crear o modificar perfiles administradores",
        )


def _require_user_deletion(actor: EditorUser, target: EditorUser) -> None:
    """Protect the current session and the administrator trust boundary."""
    if actor.user_id == target.user_id:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="No puedes eliminar tu propio usuario",
        )
    _require_admin_profile_manager(actor, target.role, None)


def _require_recovery_admin(
    db: Session,
    target: EditorUser,
    next_role: str | None,
    next_active: bool,
    next_permissions: set[str],
) -> None:
    """Keep an active administrator capable of recovering user access."""
    if target.role != "admin" or not target.active:
        return

    active_admins = list(
        db.scalars(
            select(EditorUser)
            .where(EditorUser.role == "admin", EditorUser.active.is_(True))
            .options(selectinload(EditorUser.system_permissions))
            .order_by(EditorUser.user_id)
            .with_for_update()
        )
    )
    surviving_admins = [
        user
        for user in active_admins
        if user.user_id != target.user_id
        or (next_role == "admin" and next_active)
    ]
    if not surviving_admins:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="No se puede eliminar el último administrador activo",
        )
    required_recovery_permissions = {"view_users", "edit_users"}
    has_recovery_admin = any(
        required_recovery_permissions.issubset(
            next_permissions if user.user_id == target.user_id else set(user.permissions)
        )
        for user in surviving_admins
    )
    if not has_recovery_admin:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=(
                "Debe permanecer un administrador activo con permisos para ver y editar "
                "usuarios"
            ),
        )


@router.get("", response_model=list[UserOut])
def list_users(
    _: EditorUser = Depends(require_user_viewer),
    db: Session = Depends(get_db),
) -> list[EditorUser]:
    return list(
        db.scalars(
            select(EditorUser)
            .options(
                selectinload(EditorUser.profession_permissions),
                selectinload(EditorUser.system_permissions),
                selectinload(EditorUser.totp_credential),
            )
            .order_by(EditorUser.username)
        )
    )


@router.post("", response_model=UserOut, status_code=status.HTTP_201_CREATED)
def create_user(
    payload: UserCreate,
    actor: EditorUser = Depends(require_user_manager),
    __: SessionContext = Depends(require_csrf),
    db: Session = Depends(get_db),
) -> EditorUser:
    _require_system_permission_manager(actor, payload.permissions, [])
    _require_admin_profile_manager(actor, None, payload.role)
    user = EditorUser(
        username=payload.username,
        email=payload.email,
        password_hash=hash_password(payload.password),
        role=payload.role,
        active=payload.active,
    )
    db.add(user)
    try:
        db.flush()
        _set_profession_permissions(
            db,
            user,
            payload.editable_profession_ids,
        )
        _set_system_permissions(user, payload.permissions)
        db.add(
            EditorUserRevision(
                target_user_id=user.user_id,
                actor_user_id=actor.user_id,
                action="create",
                before_json={},
                after_json=_user_snapshot(user),
            )
        )
        db.commit()
    except IntegrityError as exc:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="El nombre de usuario o el correo ya están en uso",
        ) from exc
    db.refresh(user)
    return user


@router.patch("/{user_id}", response_model=UserOut)
def update_user(
    user_id: int,
    payload: UserUpdate,
    actor: EditorUser = Depends(require_user_manager),
    __: SessionContext = Depends(require_csrf),
    db: Session = Depends(get_db),
) -> EditorUser:
    target = db.get(EditorUser, user_id)
    if target is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Usuario no encontrado")

    _require_admin_profile_manager(actor, target.role, payload.role)

    if payload.permissions is not None:
        _require_system_permission_manager(actor, payload.permissions, target.permissions)

    before = _user_snapshot(target)

    next_role = payload.role if payload.role is not None else target.role
    next_active = payload.active if payload.active is not None else target.active
    next_permissions = (
        set(payload.permissions) if payload.permissions is not None else set(target.permissions)
    )
    _require_recovery_admin(db, target, next_role, next_active, next_permissions)

    username_changed = payload.username is not None and payload.username != target.username
    if payload.username is not None:
        target.username = payload.username
    if "email" in payload.model_fields_set:
        target.email = payload.email
    target.role = next_role
    target.active = next_active
    if payload.password is not None:
        target.password_hash = hash_password(payload.password)

    permission_ids = (
        payload.editable_profession_ids
        if payload.editable_profession_ids is not None
        else target.editable_profession_ids
    )
    _set_profession_permissions(db, target, permission_ids)

    if payload.permissions is not None:
        _set_system_permissions(target, payload.permissions)

    if not target.active or payload.password is not None or username_changed:
        db.execute(delete(EditorSession).where(EditorSession.user_id == target.user_id))

    db.add(
        EditorUserRevision(
            target_user_id=target.user_id,
            actor_user_id=actor.user_id,
            action="password_reset" if payload.password is not None else "update",
            before_json=before,
            after_json=_user_snapshot(target),
        )
    )

    try:
        db.commit()
    except IntegrityError as exc:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="El nombre de usuario o el correo ya están en uso",
        ) from exc
    db.refresh(target)
    return target


@router.delete("/{user_id}/mfa", status_code=status.HTTP_204_NO_CONTENT)
def reset_user_mfa(
    user_id: int,
    actor: EditorUser = Depends(require_user_manager),
    __: SessionContext = Depends(require_csrf),
    db: Session = Depends(get_db),
) -> Response:
    """Let an administrator recover an account that lost its second factor."""
    if actor.role != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Solo un administrador puede restablecer el segundo factor",
        )
    if actor.user_id == user_id:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Desactiva tu propio segundo factor desde Seguridad",
        )

    target = db.get(EditorUser, user_id, with_for_update=True)
    if target is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Usuario no encontrado")
    credential = db.get(EditorTotpCredential, user_id, with_for_update=True)
    if credential is None or credential.confirmed_at is None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="El usuario no tiene activado el segundo factor",
        )

    before = _user_snapshot(target)
    after = {**before, "mfa_enabled": False}
    db.execute(delete(EditorSession).where(EditorSession.user_id == user_id))
    db.execute(delete(EditorMfaChallenge).where(EditorMfaChallenge.user_id == user_id))
    db.delete(credential)
    db.add(
        EditorUserRevision(
            target_user_id=user_id,
            actor_user_id=actor.user_id,
            action="mfa_reset",
            before_json=before,
            after_json=after,
        )
    )
    db.commit()
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.delete("/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_user(
    user_id: int,
    actor: EditorUser = Depends(require_user_manager),
    __: SessionContext = Depends(require_csrf),
    db: Session = Depends(get_db),
) -> Response:
    target = db.get(EditorUser, user_id, with_for_update=True)
    if target is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Usuario no encontrado")

    _require_user_deletion(actor, target)
    _require_recovery_admin(db, target, None, False, set())
    db.add(
        EditorUserRevision(
            target_user_id=target.user_id,
            actor_user_id=actor.user_id,
            action="delete",
            before_json=_user_snapshot(target),
            after_json={},
        )
    )
    db.delete(target)
    try:
        db.commit()
    except IntegrityError as exc:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="El usuario conserva relaciones que impiden eliminarlo",
        ) from exc
    return Response(status_code=status.HTTP_204_NO_CONTENT)
