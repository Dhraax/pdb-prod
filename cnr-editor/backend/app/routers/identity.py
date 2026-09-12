"""Authorized account, character, class, and tradeskill management endpoints."""

from datetime import UTC, datetime, timedelta

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import String, cast, delete, func, or_, select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session, selectinload

from app.database import get_db
from app.dependencies import (
    SessionContext,
    has_permission,
    require_cd_key_activator,
    require_character_viewer,
    require_csrf,
    require_identity_admin,
    require_identity_manager,
    require_identity_viewer,
)
from app.identity_utils import identity_hint
from app.models import (
    Account,
    AccountCdKeyHistory,
    AccountCdKeyReset,
    AccountIpHistory,
    AccountManagement,
    AccountNameHistory,
    CdKeyBan,
    Character,
    CharacterClass,
    CharacterLevelUnlock,
    CharacterProfile,
    ClassDefinition,
    EditorUser,
    IdentityRevision,
    Tradeskill,
)
from app.schemas import (
    AccountAccessCdKey,
    AccountAccessHistory,
    AccountAccessIp,
    AccountCdKeyResetState,
    AccountDetail,
    AccountListItem,
    AccountListPage,
    AccountUpdate,
    CdKeyBanUpdate,
    CharacterClassOut,
    CharacterDetail,
    CharacterPurgeRequest,
    CharacterUpdate,
    ClassDefinitionOut,
    TradeskillDefinitionOut,
    TradeskillOut,
)
from app.tradeskills import (
    TRADESKILL_DEFINITIONS,
    TRADESKILL_LEVEL_THRESHOLDS,
    tradeskill_level_from_xp,
)

router = APIRouter(prefix="/admin/identity", tags=["identity administration"])
CD_KEY_RESET_LIFETIME = timedelta(hours=24)


def _clean(value: str | None) -> str | None:
    if value is None:
        return None
    stripped = value.strip()
    return stripped or None


def _character_detail(
    character: Character,
    viewer: EditorUser | None = None,
) -> CharacterDetail:
    profile = character.profile
    can_view_identity = viewer is None or has_permission(viewer, "view_character_identity")
    can_view_timestamps = viewer is None or has_permission(viewer, "view_character_timestamps")
    can_view_abilities = viewer is None or has_permission(viewer, "view_character_abilities")
    can_view_classes = viewer is None or has_permission(viewer, "view_character_classes")
    can_view_unlocks = viewer is None or has_permission(
        viewer, "view_character_level_unlocks"
    )
    can_view_profile = viewer is None or has_permission(viewer, "view_character_profile")
    can_view_tradeskills = viewer is None or has_permission(
        viewer, "view_character_tradeskills"
    )
    classes = [
        CharacterClassOut(
            class_slot=item.class_slot,
            class_id=item.class_id,
            class_level=item.class_level,
            code=item.definition.code,
            display_name=item.definition.display_name,
        )
        for item in character.classes
    ] if can_view_classes else []
    stored_tradeskills = {item.skill_name: item for item in character.tradeskills}
    tradeskills = []
    for skill_name, display_name in (
        TRADESKILL_DEFINITIONS if can_view_tradeskills else ()
    ):
        stored = stored_tradeskills.get(skill_name)
        tradeskills.append(
            TradeskillOut(
                skill_name=skill_name,
                display_name=display_name,
                skill_level=stored.skill_level if stored else 1,
                skill_xp=stored.skill_xp if stored else 0,
                updated_at=stored.updated_at if stored else None,
            )
        )
    override = profile.display_name_override if profile else None
    observed_name = character.char_name
    display_name = (
        override or observed_name or f"Personaje #{character.character_id}"
        if can_view_identity
        else f"Personaje #{character.character_id}"
    )
    return CharacterDetail(
        character_id=character.character_id,
        account_id=character.account_id,
        character_uuid=character.character_uuid if can_view_identity else None,
        observed_name=observed_name if can_view_identity else None,
        display_name=display_name,
        display_name_override=override if can_view_identity else None,
        status=(profile.status if profile else "active") if can_view_identity else None,
        race_id=profile.race_id if profile and can_view_profile else None,
        subrace=profile.subrace if profile and can_view_profile else None,
        gender_id=profile.gender_id if profile and can_view_profile else None,
        portrait_resref=profile.portrait_resref if profile and can_view_profile else None,
        deity=profile.deity if profile and can_view_profile else None,
        strength_score=profile.strength_score if profile and can_view_abilities else None,
        dexterity_score=profile.dexterity_score if profile and can_view_abilities else None,
        constitution_score=profile.constitution_score if profile and can_view_abilities else None,
        intelligence_score=profile.intelligence_score if profile and can_view_abilities else None,
        wisdom_score=profile.wisdom_score if profile and can_view_abilities else None,
        charisma_score=profile.charisma_score if profile and can_view_abilities else None,
        admin_notes=profile.admin_notes if profile and can_view_profile else None,
        deleted_at=profile.deleted_at if profile and can_view_identity else None,
        created_at=character.created_at if can_view_timestamps else None,
        last_login_at=character.last_login_at if can_view_timestamps else None,
        updated_at=profile.updated_at if profile else None,
        rebuilds_available=character.rebuilds_available if can_view_identity else None,
        rebuilds_completed=character.rebuilds_completed if can_view_identity else None,
        total_level=sum(item.class_level for item in classes) if can_view_classes else 0,
        classes=classes,
        tradeskills=tradeskills,
        level_unlocks=(
            [item.unlock_level for item in character.level_unlocks] if can_view_unlocks else []
        ),
        applied_level_unlocks=(
            [
                item.unlock_level
                for item in character.level_unlocks
                if item.applied_at is not None
            ]
            if can_view_unlocks
            else []
        ),
    )


def _cd_key_reset_state(reset: AccountCdKeyReset | None) -> AccountCdKeyResetState:
    if reset is None:
        return AccountCdKeyResetState(status="none")
    now = datetime.now(UTC).replace(tzinfo=None)
    if reset.confirmed_at is not None:
        reset_status = "confirmed"
    elif reset.expires_at <= now:
        reset_status = "expired"
    elif reset.candidate_cd_key is not None:
        reset_status = "awaiting_confirmation"
    else:
        reset_status = "awaiting_candidate"
    return AccountCdKeyResetState(
        status=reset_status,
        candidate_hint=(
            identity_hint(reset.candidate_cd_key) if reset.candidate_cd_key is not None else None
        ),
        requested_at=reset.requested_at,
        expires_at=reset.expires_at,
        candidate_captured_at=reset.candidate_captured_at,
        confirmed_at=reset.confirmed_at,
    )


def _account_detail(account: Account, viewer: EditorUser | None = None) -> AccountDetail:
    management = account.management
    override = management.display_name_override if management else None
    observed_name = account.player_name
    return AccountDetail(
        account_id=account.account_id,
        cd_key_hint=identity_hint(account.cd_key),
        cd_key=account.cd_key if viewer is not None and viewer.role == "admin" else None,
        observed_name=observed_name,
        display_name=override or observed_name or f"Cuenta #{account.account_id}",
        display_name_override=override,
        status=management.status if management else "active",
        admin_notes=management.admin_notes if management else None,
        first_seen=account.first_seen,
        last_seen=account.last_seen,
        updated_at=management.updated_at if management else None,
        cd_key_reset=(
            _cd_key_reset_state(account.cd_key_reset)
            if viewer is None or has_permission(viewer, "activate_cd_keys")
            else AccountCdKeyResetState(status="none")
        ),
        characters=(
            [_character_detail(item, viewer) for item in account.characters]
            if viewer is None or has_permission(viewer, "view_characters")
            else []
        ),
    )


def _load_account(db: Session, account_id: int) -> Account | None:
    return db.scalar(
        select(Account)
        .where(Account.account_id == account_id)
        .options(
            selectinload(Account.management),
            selectinload(Account.cd_key_reset),
            selectinload(Account.characters).selectinload(Character.profile),
            selectinload(Account.characters)
            .selectinload(Character.classes)
            .selectinload(CharacterClass.definition),
            selectinload(Account.characters).selectinload(Character.tradeskills),
            selectinload(Account.characters).selectinload(Character.level_unlocks),
        )
    )


def _same_timestamp(current: datetime | None, supplied: datetime | None) -> bool:
    if current is None or supplied is None:
        return current is supplied
    normalized = supplied
    if normalized.tzinfo is not None:
        normalized = normalized.astimezone(UTC).replace(tzinfo=None)
    return current == normalized


@router.get("/accounts", response_model=AccountListPage)
def list_accounts(
    viewer: EditorUser = Depends(require_identity_viewer),
    db: Session = Depends(get_db),
    search: str | None = Query(default=None, max_length=96),
    offset: int = Query(default=0, ge=0),
    limit: int = Query(default=50, ge=1, le=250),
) -> AccountListPage:
    character_count = (
        select(Character.account_id, func.count().label("count"))
        .group_by(Character.account_id)
        .subquery()
    )
    query = (
        select(
            Account,
            AccountManagement,
            func.coalesce(character_count.c.count, 0),
        )
        .outerjoin(AccountManagement, AccountManagement.account_id == Account.account_id)
        .outerjoin(character_count, character_count.c.account_id == Account.account_id)
    )
    if search:
        pattern = f"%{search}%"
        search_conditions = [
            Account.player_name.like(pattern),
            AccountManagement.display_name_override.like(pattern),
            cast(Account.account_id, String).like(pattern),
        ]
        if has_permission(viewer, "view_characters"):
            character_match = select(Character.character_id).where(
                Character.account_id == Account.account_id,
                Character.char_name.like(pattern),
            )
            search_conditions.append(character_match.exists())
        if viewer.role == "admin":
            key_match = select(AccountCdKeyHistory.account_id).where(
                AccountCdKeyHistory.account_id == Account.account_id,
                AccountCdKeyHistory.cd_key.like(pattern),
            )
            ip_match = select(AccountIpHistory.account_id).where(
                AccountIpHistory.account_id == Account.account_id,
                AccountIpHistory.ip_address.like(pattern),
            )
            name_match = select(AccountNameHistory.account_id).where(
                AccountNameHistory.account_id == Account.account_id,
                AccountNameHistory.player_name.like(pattern),
            )
            search_conditions.extend(
                [
                    Account.cd_key.like(pattern),
                    key_match.exists(),
                    ip_match.exists(),
                    name_match.exists(),
                ]
            )
        query = query.where(or_(*search_conditions))
    total = db.scalar(select(func.count()).select_from(query.order_by(None).subquery())) or 0
    rows = db.execute(query.order_by(Account.last_seen.desc()).offset(offset).limit(limit)).all()
    items = []
    for account, management, count in rows:
        override = management.display_name_override if management else None
        items.append(
            AccountListItem(
                account_id=account.account_id,
                cd_key_hint=identity_hint(account.cd_key),
                cd_key=account.cd_key if viewer.role == "admin" else None,
                observed_name=account.player_name,
                display_name=override or account.player_name or f"Cuenta #{account.account_id}",
                status=management.status if management else "active",
                character_count=(
                    count if has_permission(viewer, "view_characters") else 0
                ),
                first_seen=account.first_seen,
                last_seen=account.last_seen,
            )
        )
    return AccountListPage(items=items, total=total, offset=offset, limit=limit)


@router.get("/accounts/{account_id}", response_model=AccountDetail)
def get_account(
    account_id: int,
    viewer: EditorUser = Depends(require_identity_viewer),
    db: Session = Depends(get_db),
) -> AccountDetail:
    account = _load_account(db, account_id)
    if account is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cuenta no encontrada")
    return _account_detail(account, viewer)


def _access_history(db: Session, account_id: int) -> AccountAccessHistory:
    account = db.get(Account, account_id)
    if account is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cuenta no encontrada")
    key_rows = db.execute(
        select(AccountCdKeyHistory, CdKeyBan)
        .outerjoin(CdKeyBan, CdKeyBan.cd_key == AccountCdKeyHistory.cd_key)
        .where(AccountCdKeyHistory.account_id == account_id)
        .order_by(AccountCdKeyHistory.last_seen_at.desc())
    ).all()
    ip_rows = db.scalars(
        select(AccountIpHistory)
        .where(AccountIpHistory.account_id == account_id)
        .order_by(AccountIpHistory.last_seen_at.desc())
    )
    return AccountAccessHistory(
        cd_keys=[
            AccountAccessCdKey(
                cd_key=item.cd_key,
                is_primary=item.cd_key == account.cd_key,
                first_seen_at=item.first_seen_at,
                last_seen_at=item.last_seen_at,
                attempt_count=item.attempt_count,
                verified_count=item.verified_count,
                last_player_name=item.last_player_name,
                banned=bool(ban and ban.active),
                ban_reason=ban.reason if ban and ban.active else None,
                banned_at=ban.banned_at if ban else None,
                unbanned_at=ban.unbanned_at if ban else None,
            )
            for item, ban in key_rows
        ],
        ip_addresses=[
            AccountAccessIp(
                ip_address=item.ip_address,
                first_seen_at=item.first_seen_at,
                last_seen_at=item.last_seen_at,
                attempt_count=item.attempt_count,
                verified_count=item.verified_count,
            )
            for item in ip_rows
        ],
    )


@router.get("/accounts/{account_id}/access-history", response_model=AccountAccessHistory)
def get_account_access_history(
    account_id: int,
    _: EditorUser = Depends(require_identity_admin),
    db: Session = Depends(get_db),
) -> AccountAccessHistory:
    if db.get(Account, account_id) is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cuenta no encontrada")
    return _access_history(db, account_id)


def _set_cd_key_ban(
    db: Session,
    account_id: int,
    cd_key: str,
    active: bool,
    reason: str | None,
    actor_user_id: int,
) -> AccountAccessHistory:
    history = db.get(AccountCdKeyHistory, (account_id, cd_key))
    if history is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="La CD key no figura en el historial de esta cuenta",
        )
    now = datetime.now(UTC).replace(tzinfo=None)
    ban = db.get(CdKeyBan, cd_key, with_for_update=True)
    before = {
        "account_id": account_id,
        "cd_key": cd_key,
        "banned": bool(ban and ban.active),
        "reason": ban.reason if ban else None,
    }
    if ban is None:
        ban = CdKeyBan(
            cd_key=cd_key,
            active=active,
            reason=_clean(reason) if active else None,
            banned_at=now,
            unbanned_at=None if active else now,
            updated_at=now,
        )
        db.add(ban)
    else:
        ban.active = active
        ban.reason = _clean(reason) if active else None
        ban.banned_at = now if active else ban.banned_at
        ban.unbanned_at = None if active else now
        ban.updated_at = now
    after = {
        "account_id": account_id,
        "cd_key": cd_key,
        "banned": active,
        "reason": ban.reason,
    }
    db.add(
        IdentityRevision(
            target_type="account",
            target_id=account_id,
            actor_user_id=actor_user_id,
            action="cdkey_ban" if active else "cdkey_unban",
            before_json=before,
            after_json=after,
        )
    )
    try:
        db.commit()
    except IntegrityError as exc:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="No se pudo cambiar el baneo de la CD key",
        ) from exc
    return _access_history(db, account_id)


@router.post(
    "/accounts/{account_id}/cd-keys/{cd_key}/ban",
    response_model=AccountAccessHistory,
)
def ban_cd_key(
    account_id: int,
    cd_key: str,
    payload: CdKeyBanUpdate,
    context: SessionContext = Depends(require_csrf),
    _: EditorUser = Depends(require_identity_admin),
    db: Session = Depends(get_db),
) -> AccountAccessHistory:
    return _set_cd_key_ban(
        db, account_id, cd_key, True, payload.reason, context.user.user_id
    )


@router.delete(
    "/accounts/{account_id}/cd-keys/{cd_key}/ban",
    response_model=AccountAccessHistory,
)
def unban_cd_key(
    account_id: int,
    cd_key: str,
    context: SessionContext = Depends(require_csrf),
    _: EditorUser = Depends(require_identity_admin),
    db: Session = Depends(get_db),
) -> AccountAccessHistory:
    return _set_cd_key_ban(db, account_id, cd_key, False, None, context.user.user_id)


@router.post(
    "/accounts/{account_id}/cd-keys/{cd_key}/primary",
    response_model=AccountDetail,
)
def set_primary_cd_key(
    account_id: int,
    cd_key: str,
    context: SessionContext = Depends(require_csrf),
    db: Session = Depends(get_db),
) -> AccountDetail:
    require_identity_admin(context.user)
    require_cd_key_activator(context.user)

    account = db.get(Account, account_id, with_for_update=True)
    if account is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cuenta no encontrada")
    history = db.get(AccountCdKeyHistory, (account_id, cd_key), with_for_update=True)
    if history is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="La CD key no figura en el historial de esta cuenta",
        )
    if account.cd_key == cd_key:
        return _account_detail(_load_account(db, account_id), context.user)

    ban = db.get(CdKeyBan, cd_key, with_for_update=True)
    if ban is not None and ban.active:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="La CD key está baneada; desbanéala antes de asignarla",
        )
    conflicting_account_id = db.scalar(
        select(Account.account_id)
        .where(Account.cd_key == cd_key, Account.account_id != account_id)
        .with_for_update()
    )
    if conflicting_account_id is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="La CD key ya es la principal de otra cuenta",
        )

    before = _account_detail(_load_account(db, account_id)).model_dump(mode="json")
    reset = db.get(AccountCdKeyReset, account_id, with_for_update=True)
    account.cd_key = cd_key
    if reset is not None:
        db.delete(reset)
    try:
        db.flush()
        db.expire_all()
        after = _account_detail(_load_account(db, account_id)).model_dump(mode="json")
        db.add(
            IdentityRevision(
                target_type="account",
                target_id=account_id,
                actor_user_id=context.user.user_id,
                action="cdkey_primary",
                before_json=before,
                after_json=after,
            )
        )
        db.commit()
    except IntegrityError as exc:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="La CD key ya no puede asignarse como principal a esta cuenta",
        ) from exc
    return _account_detail(_load_account(db, account_id), context.user)


@router.get("/classes", response_model=list[ClassDefinitionOut])
def class_definitions(
    viewer: EditorUser = Depends(require_character_viewer),
    db: Session = Depends(get_db),
) -> list[ClassDefinitionOut]:
    if not has_permission(viewer, "view_character_classes"):
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Sin acceso a clases")
    rows = db.scalars(
        select(ClassDefinition)
        .where(ClassDefinition.enabled.is_(True))
        .order_by(ClassDefinition.display_name, ClassDefinition.class_id)
    )
    return [ClassDefinitionOut.model_validate(row, from_attributes=True) for row in rows]


@router.get("/tradeskills", response_model=list[TradeskillDefinitionOut])
def tradeskill_definitions(
    viewer: EditorUser = Depends(require_character_viewer),
) -> list[TradeskillDefinitionOut]:
    if not has_permission(viewer, "view_character_tradeskills"):
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Sin acceso a oficios")
    return [
        TradeskillDefinitionOut(
            skill_name=skill_name,
            display_name=display_name,
            level_thresholds=list(TRADESKILL_LEVEL_THRESHOLDS),
        )
        for skill_name, display_name in TRADESKILL_DEFINITIONS
    ]


@router.patch("/accounts/{account_id}", response_model=AccountDetail)
def update_account(
    account_id: int,
    payload: AccountUpdate,
    context: SessionContext = Depends(require_csrf),
    _: EditorUser = Depends(require_identity_manager),
    db: Session = Depends(get_db),
) -> AccountDetail:
    account = db.get(Account, account_id, with_for_update=True)
    if account is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cuenta no encontrada")
    management = db.get(AccountManagement, account_id, with_for_update=True)
    current_updated_at = management.updated_at if management else None
    if not _same_timestamp(current_updated_at, payload.updated_at):
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="La cuenta cambió después de abrirla; recarga antes de guardar",
        )
    before = _account_detail(_load_account(db, account_id)).model_dump(mode="json")
    if management is None:
        management = AccountManagement(account_id=account_id)
        db.add(management)
    management.display_name_override = _clean(payload.display_name_override)
    management.status = payload.status
    management.admin_notes = _clean(payload.admin_notes)
    management.updated_by = context.user.user_id
    try:
        db.flush()
        db.expire_all()
        after = _account_detail(_load_account(db, account_id)).model_dump(mode="json")
        db.add(
            IdentityRevision(
                target_type="account",
                target_id=account_id,
                actor_user_id=context.user.user_id,
                action="update",
                before_json=before,
                after_json=after,
            )
        )
        db.commit()
    except IntegrityError as exc:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="La cuenta incumple una restricción de integridad",
        ) from exc
    refreshed = _load_account(db, account_id)
    return _account_detail(refreshed, context.user)


@router.post("/accounts/{account_id}/cd-key-reset", response_model=AccountDetail)
def request_cd_key_reset(
    account_id: int,
    context: SessionContext = Depends(require_csrf),
    _: EditorUser = Depends(require_cd_key_activator),
    db: Session = Depends(get_db),
) -> AccountDetail:
    account = db.get(Account, account_id, with_for_update=True)
    if account is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cuenta no encontrada")
    reset = db.get(AccountCdKeyReset, account_id, with_for_update=True)
    now = datetime.now(UTC).replace(tzinfo=None)
    if reset is not None and reset.confirmed_at is None and reset.expires_at > now:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Ya existe una recaptura activa; cancélala antes de iniciar otra",
        )
    before = _account_detail(_load_account(db, account_id)).model_dump(mode="json")
    if reset is None:
        reset = AccountCdKeyReset(account_id=account_id, expires_at=now + CD_KEY_RESET_LIFETIME)
        db.add(reset)
    reset.candidate_cd_key = None
    reset.requested_by = context.user.user_id
    reset.requested_at = now
    reset.expires_at = now + CD_KEY_RESET_LIFETIME
    reset.candidate_captured_at = None
    reset.confirmed_by = None
    reset.confirmed_at = None
    try:
        db.flush()
        db.expire_all()
        after = _account_detail(_load_account(db, account_id)).model_dump(mode="json")
        db.add(
            IdentityRevision(
                target_type="account",
                target_id=account_id,
                actor_user_id=context.user.user_id,
                action="cdkey_request",
                before_json=before,
                after_json=after,
            )
        )
        db.commit()
    except IntegrityError as exc:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="No se pudo iniciar la recaptura de CD key",
        ) from exc
    return _account_detail(_load_account(db, account_id), context.user)


@router.delete("/accounts/{account_id}/cd-key-reset", response_model=AccountDetail)
def cancel_cd_key_reset(
    account_id: int,
    context: SessionContext = Depends(require_csrf),
    _: EditorUser = Depends(require_cd_key_activator),
    db: Session = Depends(get_db),
) -> AccountDetail:
    account = db.get(Account, account_id, with_for_update=True)
    if account is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cuenta no encontrada")
    reset = db.get(AccountCdKeyReset, account_id, with_for_update=True)
    if reset is None or reset.confirmed_at is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="No existe una recaptura pendiente que pueda cancelarse",
        )
    before = _account_detail(_load_account(db, account_id)).model_dump(mode="json")
    db.delete(reset)
    try:
        db.flush()
        db.expire_all()
        after = _account_detail(_load_account(db, account_id)).model_dump(mode="json")
        db.add(
            IdentityRevision(
                target_type="account",
                target_id=account_id,
                actor_user_id=context.user.user_id,
                action="cdkey_cancel",
                before_json=before,
                after_json=after,
            )
        )
        db.commit()
    except IntegrityError as exc:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="No se pudo cancelar la recaptura de CD key",
        ) from exc
    return _account_detail(_load_account(db, account_id), context.user)


@router.post("/accounts/{account_id}/cd-key-reset/confirm", response_model=AccountDetail)
def confirm_cd_key_reset(
    account_id: int,
    context: SessionContext = Depends(require_csrf),
    _: EditorUser = Depends(require_cd_key_activator),
    db: Session = Depends(get_db),
) -> AccountDetail:
    account = db.get(Account, account_id, with_for_update=True)
    if account is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cuenta no encontrada")
    reset = db.get(AccountCdKeyReset, account_id, with_for_update=True)
    now = datetime.now(UTC).replace(tzinfo=None)
    if reset is None or reset.confirmed_at is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="No existe una candidata pendiente de confirmación",
        )
    if reset.expires_at <= now:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="La recaptura ha caducado; inicia una nueva",
        )
    if reset.candidate_cd_key is None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Todavía no se ha capturado una CD key candidata",
        )
    candidate_cd_key = reset.candidate_cd_key
    conflicting_account_id = db.scalar(
        select(Account.account_id).where(
            Account.cd_key == candidate_cd_key,
            Account.account_id != account_id,
        )
    )
    if conflicting_account_id is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="La CD key candidata ya pertenece a otra cuenta",
        )
    before = _account_detail(_load_account(db, account_id)).model_dump(mode="json")
    account.cd_key = candidate_cd_key
    reset.candidate_cd_key = None
    reset.confirmed_by = context.user.user_id
    reset.confirmed_at = now
    try:
        db.flush()
        db.expire_all()
        after = _account_detail(_load_account(db, account_id)).model_dump(mode="json")
        db.add(
            IdentityRevision(
                target_type="account",
                target_id=account_id,
                actor_user_id=context.user.user_id,
                action="cdkey_confirm",
                before_json=before,
                after_json=after,
            )
        )
        db.commit()
    except IntegrityError as exc:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="La CD key candidata ya no puede asignarse a esta cuenta",
        ) from exc
    return _account_detail(_load_account(db, account_id), context.user)


@router.patch("/characters/{character_id}", response_model=CharacterDetail)
def update_character(
    character_id: int,
    payload: CharacterUpdate,
    context: SessionContext = Depends(require_csrf),
    db: Session = Depends(get_db),
) -> CharacterDetail:
    requested_fields = payload.model_fields_set - {"updated_at"}
    for base_permission in ("view_accounts", "view_characters"):
        if not has_permission(context.user, base_permission):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Falta el permiso {base_permission}",
            )
    permission_fields = {
        "edit_character_identity": {
            "account_id",
            "display_name_override",
            "status",
        },
        "edit_character_profile": {
            "race_id",
            "subrace",
            "gender_id",
            "portrait_resref",
            "deity",
            "admin_notes",
        },
        "edit_character_level_unlocks": {"level_unlocks"},
        "edit_character_tradeskills": {"tradeskills"},
    }
    permission_views = {
        "edit_character_identity": "view_character_identity",
        "edit_character_profile": "view_character_profile",
        "edit_character_level_unlocks": "view_character_level_unlocks",
        "edit_character_tradeskills": "view_character_tradeskills",
    }
    if not requested_fields:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail="No se recibió ninguna sección editable del personaje",
        )
    for permission_name, fields in permission_fields.items():
        required_permissions = {permission_name, permission_views[permission_name]}
        if requested_fields & fields and not all(
            has_permission(context.user, required) for required in required_permissions
        ):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Falta el permiso {permission_name}",
            )
    if payload.account_id is None and "account_id" in requested_fields:
        raise HTTPException(status_code=422, detail="La cuenta propietaria no puede estar vacía")
    if payload.status is None and "status" in requested_fields:
        raise HTTPException(status_code=422, detail="El estado no puede estar vacío")

    character = db.get(Character, character_id, with_for_update=True)
    if character is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Personaje no encontrado")
    if payload.account_id is not None and db.get(Account, payload.account_id) is None:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY, detail="Cuenta destino no encontrada"
        )
    profile = db.get(CharacterProfile, character_id, with_for_update=True)
    if profile is not None and profile.status == "deleted":
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=(
                "El personaje eliminado es una lápida histórica de solo lectura; "
                "usa las acciones administrativas específicas"
            ),
        )
    current_updated_at = profile.updated_at if profile else None
    if not _same_timestamp(current_updated_at, payload.updated_at):
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="El personaje cambió después de abrirlo; recarga antes de guardar",
        )
    stored_tradeskills = {}
    if payload.tradeskills is not None:
        stored_tradeskills = {
            item.skill_name: item
            for item in db.scalars(
                select(Tradeskill)
                .where(Tradeskill.character_id == character_id)
                .with_for_update()
            )
        }
    stored_unlocks: set[int] = set()
    requested_unlocks: set[int] = set()
    if payload.level_unlocks is not None:
        stored_unlocks = set(
            db.scalars(
                select(CharacterLevelUnlock.unlock_level)
                .where(CharacterLevelUnlock.character_id == character_id)
                .with_for_update()
            )
        )
        requested_unlocks = set(payload.level_unlocks)
    if payload.level_unlocks is not None and not stored_unlocks.issubset(requested_unlocks):
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail=(
                "Un desbloqueo concedido no puede retirarse: la base de campaña del "
                "personaje ya puede haberlo aplicado"
            ),
        )
    for item in payload.tradeskills or []:
        stored = stored_tradeskills.get(item.skill_name)
        stored_updated_at = stored.updated_at if stored else None
        if not _same_timestamp(stored_updated_at, item.updated_at):
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail=f"El oficio {item.skill_name} cambió; recarga antes de guardar",
            )
    before_character = db.scalar(
        select(Character)
        .where(Character.character_id == character_id)
        .options(
            selectinload(Character.profile),
            selectinload(Character.classes).selectinload(CharacterClass.definition),
            selectinload(Character.tradeskills),
            selectinload(Character.level_unlocks),
        )
    )
    before = _character_detail(before_character).model_dump(mode="json")
    profile_fields = permission_fields["edit_character_identity"] | permission_fields[
        "edit_character_profile"
    ]
    if profile is None and requested_fields & profile_fields:
        profile = CharacterProfile(character_id=character_id)
        db.add(profile)
    if "account_id" in requested_fields:
        character.account_id = payload.account_id
    if profile is not None:
        if "display_name_override" in requested_fields:
            profile.display_name_override = _clean(payload.display_name_override)
        if "status" in requested_fields:
            profile.status = payload.status
            if payload.status == "deleted":
                profile.deleted_at = datetime.now(UTC).replace(tzinfo=None)
        if "race_id" in requested_fields:
            profile.race_id = payload.race_id
        if "subrace" in requested_fields:
            profile.subrace = _clean(payload.subrace)
        if "gender_id" in requested_fields:
            profile.gender_id = payload.gender_id
        if "portrait_resref" in requested_fields:
            profile.portrait_resref = _clean(payload.portrait_resref)
        if "deity" in requested_fields:
            profile.deity = _clean(payload.deity)
        if "admin_notes" in requested_fields:
            profile.admin_notes = _clean(payload.admin_notes)
        profile.updated_by = context.user.user_id
        # Profile and ownership changes advance the character concurrency token.
        profile.updated_at = datetime.now(UTC).replace(tzinfo=None)
    try:
        for item in payload.tradeskills or []:
            stored = stored_tradeskills.get(item.skill_name)
            if stored is None:
                stored = Tradeskill(
                    character_id=character_id,
                    skill_name=item.skill_name,
                    skill_level=1,
                    skill_xp=0,
                )
                db.add(stored)
            stored.skill_xp = item.skill_xp
            stored.skill_level = tradeskill_level_from_xp(item.skill_xp)
        for unlock_level in sorted(requested_unlocks - stored_unlocks):
            db.add(
                CharacterLevelUnlock(
                    character_id=character_id,
                    unlock_level=unlock_level,
                    granted_by=context.user.user_id,
                )
            )
        db.flush()
        db.expire_all()
        after_character = db.scalar(
            select(Character)
            .where(Character.character_id == character_id)
            .options(
                selectinload(Character.profile),
                selectinload(Character.classes).selectinload(CharacterClass.definition),
                selectinload(Character.tradeskills),
                selectinload(Character.level_unlocks),
            )
        )
        after = _character_detail(after_character).model_dump(mode="json")
        db.add(
            IdentityRevision(
                target_type="character",
                target_id=character_id,
                actor_user_id=context.user.user_id,
                action="update",
                before_json=before,
                after_json=after,
            )
        )
        db.commit()
    except IntegrityError as exc:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="El personaje incumple una restricción de integridad",
        ) from exc
    refreshed = db.scalar(
        select(Character)
        .where(Character.character_id == character_id)
        .options(
            selectinload(Character.profile),
            selectinload(Character.classes).selectinload(CharacterClass.definition),
            selectinload(Character.tradeskills),
            selectinload(Character.level_unlocks),
        )
    )
    return _character_detail(refreshed, context.user)


@router.post("/characters/{character_id}/purge", response_model=AccountDetail)
def purge_deleted_character(
    character_id: int,
    payload: CharacterPurgeRequest,
    context: SessionContext = Depends(require_csrf),
    db: Session = Depends(get_db),
) -> AccountDetail:
    require_identity_admin(context.user)
    character = db.get(Character, character_id, with_for_update=True)
    profile = db.get(CharacterProfile, character_id, with_for_update=True)
    if character is None or profile is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Personaje no encontrado")
    if profile.status != "deleted":
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Solo puede purgarse un personaje que ya esté marcado como eliminado",
        )
    if not _same_timestamp(profile.updated_at, payload.updated_at):
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="El personaje cambió después de abrirlo; recarga antes de purgar",
        )

    account_id = character.account_id
    db.execute(
        delete(IdentityRevision).where(
            IdentityRevision.target_type == "character",
            IdentityRevision.target_id == character_id,
        )
    )
    result = db.execute(delete(Character).where(Character.character_id == character_id))
    if result.rowcount != 1:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="No se pudo purgar exactamente un personaje",
        )
    db.add(
        IdentityRevision(
            target_type="account",
            target_id=account_id,
            actor_user_id=context.user.user_id,
            action="char_purge",
            before_json={"purged_character_id": character_id, "status": "deleted"},
            after_json={"purged_character_id": character_id, "purged": True},
        )
    )
    try:
        db.commit()
    except IntegrityError as exc:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="La purga incumple una restricción de integridad",
        ) from exc
    return _account_detail(_load_account(db, account_id), context.user)
