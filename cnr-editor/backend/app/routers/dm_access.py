"""DM public CD-key whitelist administration."""

from fastapi import APIRouter, Depends, HTTPException, Path, Response, status
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.database import get_db
from app.dependencies import SessionContext, require_csrf, require_dm_access_manager
from app.models import (
    CdKeyBan,
    DmCdKeyWhitelist,
    DmCdKeyWhitelistRevision,
    EditorUser,
)
from app.schemas import DmCdKeyWhitelistCreate, DmCdKeyWhitelistOut

router = APIRouter(prefix="/admin/dm-access", tags=["DM access administration"])


def _snapshot(entry: DmCdKeyWhitelist) -> dict[str, str | None]:
    return {
        "cd_key": entry.cd_key,
        "display_name": entry.display_name,
        "added_at": entry.added_at.isoformat(),
    }


@router.get("/whitelist", response_model=list[DmCdKeyWhitelistOut])
def list_dm_cd_keys(
    _: EditorUser = Depends(require_dm_access_manager),
    db: Session = Depends(get_db),
) -> list[DmCdKeyWhitelistOut]:
    rows = db.execute(
        select(DmCdKeyWhitelist, CdKeyBan.active)
        .outerjoin(CdKeyBan, DmCdKeyWhitelist.cd_key == CdKeyBan.cd_key)
        .order_by(DmCdKeyWhitelist.display_name, DmCdKeyWhitelist.cd_key)
    ).all()
    return [
        DmCdKeyWhitelistOut(
            cd_key=entry.cd_key,
            display_name=entry.display_name,
            added_at=entry.added_at,
            globally_banned=bool(banned),
        )
        for entry, banned in rows
    ]


@router.post(
    "/whitelist",
    response_model=DmCdKeyWhitelistOut,
    status_code=status.HTTP_201_CREATED,
)
def add_dm_cd_key(
    payload: DmCdKeyWhitelistCreate,
    context: SessionContext = Depends(require_csrf),
    db: Session = Depends(get_db),
) -> DmCdKeyWhitelistOut:
    require_dm_access_manager(context.user)
    if db.get(DmCdKeyWhitelist, payload.cd_key) is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="La CD key ya está autorizada para acceder como DM",
        )
    if db.scalar(
        select(CdKeyBan.active).where(
            CdKeyBan.cd_key == payload.cd_key,
            CdKeyBan.active.is_(True),
        )
    ):
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="La CD key tiene un baneo global activo",
        )

    entry = DmCdKeyWhitelist(
        cd_key=payload.cd_key,
        display_name=payload.display_name,
    )
    db.add(entry)
    try:
        db.flush()
        db.refresh(entry)
        after = _snapshot(entry)
        db.add(
            DmCdKeyWhitelistRevision(
                cd_key=entry.cd_key,
                actor_user_id=context.user.user_id,
                action="whitelist_add",
                before_json={},
                after_json=after,
            )
        )
        db.commit()
    except IntegrityError as exc:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="No se pudo autorizar la CD key",
        ) from exc
    return DmCdKeyWhitelistOut(
        cd_key=entry.cd_key,
        display_name=entry.display_name,
        added_at=entry.added_at,
        globally_banned=False,
    )


@router.delete("/whitelist/{cd_key}", status_code=status.HTTP_204_NO_CONTENT)
def remove_dm_cd_key(
    cd_key: str = Path(min_length=1, max_length=16, pattern=r"^[A-Za-z0-9]+$"),
    context: SessionContext = Depends(require_csrf),
    db: Session = Depends(get_db),
) -> Response:
    require_dm_access_manager(context.user)
    normalized_cd_key = cd_key.upper()
    entry = db.get(DmCdKeyWhitelist, normalized_cd_key)
    if entry is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="La CD key no está en la whitelist de DMs",
        )
    before = _snapshot(entry)
    db.delete(entry)
    db.add(
        DmCdKeyWhitelistRevision(
            cd_key=normalized_cd_key,
            actor_user_id=context.user.user_id,
            action="whitelist_remove",
            before_json=before,
            after_json={},
        )
    )
    db.commit()
    return Response(status_code=status.HTTP_204_NO_CONTENT)
