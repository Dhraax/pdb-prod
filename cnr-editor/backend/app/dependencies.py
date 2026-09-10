"""Authentication, authorization, CSRF and write-gate dependencies."""

import secrets
from dataclasses import dataclass
from datetime import UTC, datetime

from fastapi import Depends, Header, HTTPException, Request, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.config import Settings, get_settings
from app.database import get_db
from app.models import EditorSession, EditorUser
from app.security import hash_secret


@dataclass(frozen=True)
class SessionContext:
    session: EditorSession
    user: EditorUser


def get_session_context(
    request: Request,
    db: Session = Depends(get_db),
    settings: Settings = Depends(get_settings),
) -> SessionContext:
    token = request.cookies.get(settings.session_cookie_name)
    if not token:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, detail="No has iniciado sesión"
        )

    record = db.scalar(select(EditorSession).where(EditorSession.token_hash == hash_secret(token)))
    now = datetime.now(UTC).replace(tzinfo=None)
    if record is None or record.expires_at <= now or not record.user.active:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, detail="La sesión ha caducado"
        )

    return SessionContext(session=record, user=record.user)


def get_current_user(context: SessionContext = Depends(get_session_context)) -> EditorUser:
    return context.user


def require_admin(user: EditorUser = Depends(get_current_user)) -> EditorUser:
    if user.role != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Se requiere el rol de administrador",
        )
    return user


def require_dm_access_manager(
    user: EditorUser = Depends(get_current_user),
) -> EditorUser:
    """Restrict the DM CD-key whitelist to administrators and technical staff."""
    if user.role not in {"admin", "technical"}:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Se requiere el rol de administrador o equipo técnico",
        )
    return user


def has_permission(user: EditorUser, permission_name: str) -> bool:
    """Return whether a user has one explicit control-panel permission."""
    return permission_name in user.permissions


def _require_permission(user: EditorUser, permission_name: str, detail: str) -> EditorUser:
    if not has_permission(user, permission_name):
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail=detail)
    return user


def require_recipe_viewer(user: EditorUser = Depends(get_current_user)) -> EditorUser:
    return _require_permission(user, "view_recipes", "No tienes permiso para ver recetas")


def require_identity_manager(user: EditorUser = Depends(get_current_user)) -> EditorUser:
    require_identity_viewer(user)
    return _require_permission(user, "edit_accounts", "No tienes permiso para editar cuentas")


def require_identity_viewer(user: EditorUser = Depends(get_current_user)) -> EditorUser:
    return _require_permission(user, "view_accounts", "No tienes permiso para ver cuentas")


def require_identity_admin(user: EditorUser = Depends(require_admin)) -> EditorUser:
    """Require both the administrator role and explicit account visibility."""
    require_admin(user)
    return require_identity_viewer(user)


def require_cd_key_activator(user: EditorUser = Depends(get_current_user)) -> EditorUser:
    """Require the dedicated capability for controlled game-key activation."""
    require_identity_viewer(user)
    if "activate_cd_keys" not in user.permissions:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Se requiere el permiso para activar CD keys",
        )
    return user


def require_user_manager(user: EditorUser = Depends(get_current_user)) -> EditorUser:
    require_user_viewer(user)
    return _require_permission(user, "edit_users", "No tienes permiso para editar usuarios")


def require_user_viewer(user: EditorUser = Depends(get_current_user)) -> EditorUser:
    return _require_permission(user, "view_users", "No tienes permiso para ver usuarios")


def require_character_viewer(user: EditorUser = Depends(get_current_user)) -> EditorUser:
    return _require_permission(user, "view_characters", "No tienes permiso para ver personajes")


def can_edit_profession(user: EditorUser, profession_id: int) -> bool:
    """Return whether a user may mutate recipes in one profession tab."""
    return (
        has_permission(user, "view_recipes")
        and has_permission(user, "edit_recipes")
        and profession_id in user.editable_profession_ids
    )


def require_profession_edit(user: EditorUser, profession_id: int) -> None:
    """Reject recipe writes outside the user's assigned profession scope."""
    if not can_edit_profession(user, profession_id):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tienes permiso para editar este oficio",
        )


def require_csrf(
    request: Request,
    context: SessionContext = Depends(get_session_context),
    settings: Settings = Depends(get_settings),
    csrf_header: str | None = Header(default=None, alias="X-CSRF-Token"),
) -> SessionContext:
    csrf_cookie = request.cookies.get(settings.csrf_cookie_name)
    if not csrf_header or not csrf_cookie or not secrets.compare_digest(csrf_header, csrf_cookie):
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Token CSRF no válido")
    if not secrets.compare_digest(hash_secret(csrf_header), context.session.csrf_token_hash):
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Token CSRF no válido")
    return context


def require_writes_enabled(settings: Settings = Depends(get_settings)) -> None:
    if not settings.writes_enabled:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="La escritura del catálogo está desactivada hasta completar la validación",
        )
