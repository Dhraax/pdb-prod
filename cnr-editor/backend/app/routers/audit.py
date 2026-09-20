"""Administrator-only unified audit history."""

from fastapi import APIRouter, Depends, Query
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.database import get_db
from app.dependencies import require_admin
from app.models import (
    ArcaneRevision,
    CatalogueRevision,
    DmCdKeyWhitelistRevision,
    EditorUser,
    EditorUserRevision,
    IdentityRevision,
)
from app.schemas import AuditEntry, AuditPage

router = APIRouter(prefix="/admin/audit", tags=["administration"])


def _target_label(domain: str, target_id: int | str, snapshot: dict) -> str:
    """Build a stable human-readable label from the stored revision snapshot."""
    name = snapshot.get("display_name") or snapshot.get("username")
    if domain == "recipe":
        public_id = snapshot.get("public_id")
        prefix = f"Receta {public_id}" if public_id is not None else f"Receta {target_id}"
    elif domain == "arcane":
        prefix = f"Propiedad arcana {target_id}"
    elif domain == "account":
        prefix = f"Cuenta {target_id}"
    elif domain == "character":
        prefix = f"Personaje {target_id}"
    elif domain == "user":
        prefix = f"Usuario {target_id}"
    else:
        prefix = f"CD key DM {target_id}"
    return f"{prefix} · {name}" if name else prefix


def _entry(
    domain: str,
    revision: (
        CatalogueRevision
        | ArcaneRevision
        | IdentityRevision
        | EditorUserRevision
        | DmCdKeyWhitelistRevision
    ),
    actor_username: str | None,
) -> AuditEntry:
    """Normalize one domain revision for the unified administrative view."""
    target_id = (
        revision.recipe_id
        if isinstance(revision, CatalogueRevision)
        else revision.arcane_id
        if isinstance(revision, ArcaneRevision)
        else revision.target_user_id
        if isinstance(revision, EditorUserRevision)
        else revision.cd_key
        if isinstance(revision, DmCdKeyWhitelistRevision)
        else revision.target_id
    )
    snapshot = revision.after_json or revision.before_json
    return AuditEntry(
        revision_key=f"{domain}:{revision.revision_id}",
        domain=domain,
        target_id=target_id,
        target_label=_target_label(domain, target_id, snapshot),
        action=revision.action,
        changed_at=revision.changed_at,
        actor_user_id=revision.actor_user_id,
        actor_username=actor_username,
        before=revision.before_json,
        after=revision.after_json,
        note=(revision.note if isinstance(revision, CatalogueRevision | ArcaneRevision) else None),
    )


@router.get("", response_model=AuditPage)
def list_audit_entries(
    _: EditorUser = Depends(require_admin),
    offset: int = Query(default=0, ge=0),
    limit: int = Query(default=50, ge=1, le=200),
    db: Session = Depends(get_db),
) -> AuditPage:
    """Return the newest catalogue, arcane, identity, DM-access and user revisions."""
    fetch_limit = offset + limit
    catalogue_rows = db.execute(
        select(CatalogueRevision, EditorUser.username)
        .outerjoin(EditorUser, CatalogueRevision.actor_user_id == EditorUser.user_id)
        .order_by(CatalogueRevision.changed_at.desc(), CatalogueRevision.revision_id.desc())
        .limit(fetch_limit)
    ).all()
    arcane_rows = db.execute(
        select(ArcaneRevision, EditorUser.username)
        .outerjoin(EditorUser, ArcaneRevision.actor_user_id == EditorUser.user_id)
        .order_by(ArcaneRevision.changed_at.desc(), ArcaneRevision.revision_id.desc())
        .limit(fetch_limit)
    ).all()
    identity_rows = db.execute(
        select(IdentityRevision, EditorUser.username)
        .outerjoin(EditorUser, IdentityRevision.actor_user_id == EditorUser.user_id)
        .order_by(IdentityRevision.changed_at.desc(), IdentityRevision.revision_id.desc())
        .limit(fetch_limit)
    ).all()
    user_rows = db.execute(
        select(EditorUserRevision, EditorUser.username)
        .outerjoin(EditorUser, EditorUserRevision.actor_user_id == EditorUser.user_id)
        .order_by(EditorUserRevision.changed_at.desc(), EditorUserRevision.revision_id.desc())
        .limit(fetch_limit)
    ).all()
    dm_access_rows = db.execute(
        select(DmCdKeyWhitelistRevision, EditorUser.username)
        .outerjoin(
            EditorUser,
            DmCdKeyWhitelistRevision.actor_user_id == EditorUser.user_id,
        )
        .order_by(
            DmCdKeyWhitelistRevision.changed_at.desc(),
            DmCdKeyWhitelistRevision.revision_id.desc(),
        )
        .limit(fetch_limit)
    ).all()

    entries = [
        *(_entry("recipe", revision, username) for revision, username in catalogue_rows),
        *(_entry("arcane", revision, username) for revision, username in arcane_rows),
        *(
            _entry(revision.target_type, revision, username)
            for revision, username in identity_rows
        ),
        *(_entry("user", revision, username) for revision, username in user_rows),
        *(_entry("dm_access", revision, username) for revision, username in dm_access_rows),
    ]
    entries.sort(
        key=lambda item: (
            item.changed_at,
            item.domain,
            int(item.revision_key.rsplit(":", 1)[1]),
        ),
        reverse=True,
    )
    total = sum(
        db.scalar(select(func.count()).select_from(model)) or 0
        for model in (
            CatalogueRevision,
            ArcaneRevision,
            IdentityRevision,
            EditorUserRevision,
            DmCdKeyWhitelistRevision,
        )
    )
    return AuditPage(
        items=entries[offset : offset + limit],
        total=total,
        offset=offset,
        limit=limit,
    )
