"""Validation tests for account and character administration."""

from datetime import UTC, datetime, timedelta
from types import SimpleNamespace

import pytest
from fastapi import HTTPException, Response
from pydantic import ValidationError
from sqlalchemy import create_engine, func, select
from sqlalchemy.orm import Session as DatabaseSession

from app.config import Settings
from app.dependencies import (
    can_edit_profession,
    require_admin,
    require_cd_key_activator,
    require_identity_admin,
    require_identity_manager,
    require_identity_viewer,
    require_user_manager,
)
from app.identity_utils import identity_hint
from app.models import (
    Account,
    AccountCdKeyHistory,
    AccountCdKeyReset,
    AccountIpHistory,
    CdKeyBan,
    Character,
    CharacterClass,
    CharacterLevelUnlock,
    CharacterProfile,
    ClassDefinition,
    EditorLoginThrottle,
    EditorProfessionPermission,
    EditorSession,
    EditorSystemPermission,
    EditorUser,
    IdentityRevision,
    Tradeskill,
)
from app.permissions import ROLE_PERMISSION_PRESETS, missing_permission_dependencies
from app.routers.admin import (
    _require_admin_profile_manager,
    _require_system_permission_manager,
    _require_user_deletion,
    _user_snapshot,
)
from app.routers.audit import _target_label
from app.routers.auth import login
from app.routers.identity import (
    _access_history,
    _account_detail,
    _cd_key_reset_state,
    _character_detail,
    update_character,
)
from app.schemas import (
    REBUILDS_ADDED_MAX,
    AccountUpdate,
    CharacterDetail,
    CharacterPurgeRequest,
    CharacterUpdate,
    LoginRequest,
    UserCreate,
    UserUpdate,
)
from app.security import hash_password
from app.tradeskills import TRADESKILL_LEVEL_THRESHOLDS, tradeskill_level_from_xp


def _character_payload() -> dict:
    return {
        "updated_at": None,
        "account_id": 1,
        "display_name_override": None,
        "status": "active",
        "race_id": None,
        "subrace": None,
        "gender_id": None,
        "portrait_resref": None,
        "deity": None,
        "admin_notes": None,
        "tradeskills": [
            {"skill_name": name, "skill_xp": 0, "updated_at": None}
            for name in (
                "Herreria",
                "Carpinteria",
                "Peleteria",
                "Alquimia",
                "Joyeria",
                "Arcano",
                "Sastreria",
            )
        ],
        "level_unlocks": [],
    }


def test_character_update_rejects_class_edits() -> None:
    payload = _character_payload()
    payload["classes"] = [
        {"class_slot": 1, "class_id": 4, "class_level": 10},
    ]

    with pytest.raises(ValidationError, match="Extra inputs are not permitted"):
        CharacterUpdate.model_validate(payload)


def test_inactive_panel_user_cannot_log_in() -> None:
    engine = create_engine("sqlite+pysqlite:///:memory:")
    EditorUser.__table__.create(engine)
    EditorSession.__table__.create(engine)
    EditorLoginThrottle.__table__.create(engine)
    settings = Settings(database_url="sqlite+pysqlite:///:memory:")

    with DatabaseSession(engine) as db:
        db.add(
            EditorUser(
                username="inactive-user",
                password_hash=hash_password("a-secure-inactive-password"),
                role="editor",
                active=False,
            )
        )
        db.commit()

        with pytest.raises(HTTPException) as raised:
            login(
                LoginRequest(
                    username="inactive-user",
                    password="a-secure-inactive-password",
                ),
                Response(),
                db,
                settings,
            )

        assert raised.value.status_code == 401
        assert db.scalar(select(func.count()).select_from(EditorSession)) == 0


def test_character_detail_exposes_captured_base_ability_scores() -> None:
    detail = CharacterDetail.model_validate(
        {
            "character_id": 7,
            "account_id": 3,
            "character_uuid": "1234567890ABCDEF",
            "observed_name": "Test Character",
            "display_name": "Test Character",
            "display_name_override": None,
            "status": "active",
            "race_id": 6,
            "subrace": None,
            "gender_id": 0,
            "portrait_resref": "po_test",
            "deity": None,
            "strength_score": 18,
            "dexterity_score": 14,
            "constitution_score": 16,
            "intelligence_score": 10,
            "wisdom_score": 12,
            "charisma_score": 8,
            "admin_notes": None,
            "created_at": "2026-08-14T10:00:00",
            "last_login_at": "2026-08-14T12:00:00",
            "updated_at": None,
            "rebuilds_available": 2,
            "rebuilds_completed": 3,
            "total_level": 1,
            "classes": [],
            "tradeskills": [],
            "level_unlocks": [],
            "applied_level_unlocks": [],
        }
    )

    assert detail.strength_score == 18
    assert detail.charisma_score == 8
    assert detail.rebuilds_available == 2
    assert detail.rebuilds_completed == 3


def test_character_detail_rejects_out_of_range_ability_scores() -> None:
    with pytest.raises(ValidationError):
        CharacterDetail.model_validate(
            {
                "character_id": 7,
                "account_id": 3,
                "character_uuid": "1234567890ABCDEF",
                "observed_name": None,
                "display_name": "Test Character",
                "display_name_override": None,
                "status": "active",
                "race_id": None,
                "subrace": None,
                "gender_id": None,
                "portrait_resref": None,
                "deity": None,
                "strength_score": 256,
                "dexterity_score": None,
                "constitution_score": None,
                "intelligence_score": None,
                "wisdom_score": None,
                "charisma_score": None,
                "admin_notes": None,
                "created_at": "2026-08-14T10:00:00",
                "last_login_at": None,
                "updated_at": None,
                "total_level": 0,
                "classes": [],
                "tradeskills": [],
                "level_unlocks": [],
                "applied_level_unlocks": [],
            }
        )


def test_account_status_rejects_unknown_values() -> None:
    with pytest.raises(ValidationError):
        AccountUpdate(updated_at=None, status="unknown")


@pytest.mark.parametrize("legacy_status", ["suspended", "banned", "archived"])
def test_account_status_rejects_removed_legacy_values(legacy_status: str) -> None:
    with pytest.raises(ValidationError):
        AccountUpdate(updated_at=None, status=legacy_status)


def test_account_status_accepts_blocked() -> None:
    assert AccountUpdate(updated_at=None, status="blocked").status == "blocked"


def test_character_status_rejects_retired() -> None:
    payload = _character_payload()
    payload["status"] = "retired"

    with pytest.raises(ValidationError):
        CharacterUpdate.model_validate(payload)


@pytest.mark.parametrize("status", ["active", "blocked", "deleted"])
def test_character_status_accepts_current_policy(status: str) -> None:
    payload = _character_payload()
    payload["status"] = status

    assert CharacterUpdate.model_validate(payload).status == status


@pytest.mark.parametrize(
    "portrait",
    ["po_test", "miria port_", "po-elf.f", "retrato_ñ", "¡(raro)!", "x" * 16],
)
def test_character_update_accepts_any_portrait_the_game_stores(portrait: str) -> None:
    payload = _character_payload()
    payload["portrait_resref"] = portrait

    assert CharacterUpdate.model_validate(payload).portrait_resref == portrait


def test_character_update_rejects_portrait_longer_than_its_column() -> None:
    payload = _character_payload()
    payload["portrait_resref"] = "x" * 17

    with pytest.raises(ValidationError):
        CharacterUpdate.model_validate(payload)


def test_character_purge_requires_exact_confirmation() -> None:
    with pytest.raises(ValidationError):
        CharacterPurgeRequest(
            updated_at=datetime.now(UTC),
            confirmation="eliminar",
        )

    payload = CharacterPurgeRequest(
        updated_at=datetime.now(UTC),
        confirmation="ELIMINAR",
    )
    assert payload.confirmation == "ELIMINAR"


def test_character_update_accepts_and_sorts_known_level_unlocks() -> None:
    payload = _character_payload()
    payload["level_unlocks"] = [35, 9, 21]

    assert CharacterUpdate.model_validate(payload).level_unlocks == [9, 21, 35]


def test_character_detail_distinguishes_pending_and_applied_level_unlocks() -> None:
    now = datetime.now(UTC).replace(tzinfo=None)
    character = Character(
        character_id=7,
        character_uuid="1234567890ABCDEF",
        account_id=3,
        char_name="Test Character",
        created_at=now,
        last_login_at=now,
        rebuilds_available=2,
        rebuilds_completed=0,
    )
    character.profile = None
    character.classes = []
    character.tradeskills = []
    character.level_unlocks = [
        CharacterLevelUnlock(
            character_id=7,
            unlock_level=9,
            granted_by=None,
            granted_at=now,
            applied_at=None,
        ),
        CharacterLevelUnlock(
            character_id=7,
            unlock_level=13,
            granted_by=None,
            granted_at=now,
            applied_at=now,
        ),
    ]

    detail = _character_detail(character)

    assert detail.level_unlocks == [9, 13]
    assert detail.applied_level_unlocks == [13]


@pytest.mark.parametrize("level_unlocks", [[8], [40], [9, 9]])
def test_character_update_rejects_invalid_level_unlocks(level_unlocks: list[int]) -> None:
    payload = _character_payload()
    payload["level_unlocks"] = level_unlocks

    with pytest.raises(ValidationError):
        CharacterUpdate.model_validate(payload)


def test_identity_hints_do_not_expose_short_or_full_keys() -> None:
    assert identity_hint("12345678") == "••••••••"
    assert identity_hint("1234567890ABCDEF") == "1234…CDEF"


def test_only_administrator_account_response_exposes_full_cd_key() -> None:
    now = datetime.now(UTC).replace(tzinfo=None)
    account = Account(
        account_id=3,
        cd_key="1234567890ABCDEF",
        player_name="Test account",
        first_seen=now,
        last_seen=now,
    )
    admin = EditorUser(
        username="raw-key-admin",
        password_hash="unused",
        role="admin",
        active=True,
    )
    technical = EditorUser(
        username="raw-key-technical",
        password_hash="unused",
        role="technical",
        active=True,
    )

    assert _account_detail(account, admin).cd_key == "1234567890ABCDEF"
    assert _account_detail(account, technical).cd_key is None
    assert _account_detail(account, None).cd_key is None


def test_access_history_requires_admin_role_and_account_permission() -> None:
    admin_without_access = EditorUser(
        username="history-admin-without-access",
        password_hash="unused",
        role="admin",
        active=True,
    )
    admin_with_access = EditorUser(
        username="history-admin-with-access",
        password_hash="unused",
        role="admin",
        active=True,
        system_permissions=[EditorSystemPermission(permission_name="view_accounts")],
    )
    technical_with_access = EditorUser(
        username="history-technical",
        password_hash="unused",
        role="technical",
        active=True,
        system_permissions=[EditorSystemPermission(permission_name="view_accounts")],
    )

    with pytest.raises(HTTPException):
        require_identity_admin(admin_without_access)
    with pytest.raises(HTTPException):
        require_identity_admin(technical_with_access)
    assert require_identity_admin(admin_with_access) is admin_with_access


def test_access_history_marks_only_the_current_account_key_as_primary() -> None:
    engine = create_engine("sqlite+pysqlite:///:memory:")
    for table in (
        Account.__table__,
        AccountCdKeyHistory.__table__,
        AccountIpHistory.__table__,
        CdKeyBan.__table__,
    ):
        table.create(engine)
    now = datetime.now(UTC).replace(tzinfo=None)

    with DatabaseSession(engine) as db:
        db.add(
            Account(
                account_id=3,
                cd_key="CURRENTKEY",
                player_name="Test account",
                first_seen=now,
                last_seen=now,
            )
        )
        db.add_all(
            [
                AccountCdKeyHistory(
                    account_id=3,
                    cd_key="CURRENTKEY",
                    first_seen_at=now,
                    last_seen_at=now,
                    attempt_count=1,
                    verified_count=1,
                    last_player_name="Test account",
                ),
                AccountCdKeyHistory(
                    account_id=3,
                    cd_key="OBSERVEDKEY",
                    first_seen_at=now,
                    last_seen_at=now,
                    attempt_count=1,
                    verified_count=0,
                    last_player_name="Test account",
                ),
            ]
        )
        db.commit()

        history = _access_history(db, 3)

    primary = {item.cd_key: item.is_primary for item in history.cd_keys}
    assert primary == {"CURRENTKEY": True, "OBSERVEDKEY": False}


def test_cd_key_reset_candidate_is_masked_and_requires_confirmation() -> None:
    now = datetime.now(UTC).replace(tzinfo=None)
    reset = AccountCdKeyReset(
        account_id=3,
        candidate_cd_key="1234567890ABCDEF",
        requested_at=now,
        expires_at=now + timedelta(hours=1),
        candidate_captured_at=now,
    )

    state = _cd_key_reset_state(reset)

    assert state.status == "awaiting_confirmation"
    assert state.candidate_hint == "1234…CDEF"
    assert "1234567890ABCDEF" not in state.model_dump_json()


def test_cd_key_reset_expiry_prevents_candidate_confirmation_state() -> None:
    now = datetime.now(UTC).replace(tzinfo=None)
    reset = AccountCdKeyReset(
        account_id=3,
        candidate_cd_key="1234567890ABCDEF",
        requested_at=now - timedelta(days=2),
        expires_at=now - timedelta(days=1),
        candidate_captured_at=now - timedelta(days=2),
    )

    assert _cd_key_reset_state(reset).status == "expired"


def test_identity_administration_rejects_user_without_permission() -> None:
    editor = EditorUser(
        username="identity-test-editor",
        password_hash="unused",
        role="editor",
        active=True,
    )

    with pytest.raises(HTTPException) as raised:
        require_identity_manager(editor)

    assert raised.value.status_code == 403


def test_identity_administration_accepts_explicit_account_edit_permission() -> None:
    technical = EditorUser(
        username="identity-test-technical",
        password_hash="unused",
        role="technical",
        active=True,
        system_permissions=[
            EditorSystemPermission(permission_name="view_accounts"),
            EditorSystemPermission(permission_name="edit_accounts"),
        ],
    )

    assert require_identity_manager(technical) is technical


def test_explicit_account_view_permission_does_not_grant_account_edits() -> None:
    dungeon_master = EditorUser(
        username="identity-test-dungeon-master",
        password_hash="unused",
        role="dungeon_master",
        active=True,
        system_permissions=[EditorSystemPermission(permission_name="view_accounts")],
    )

    assert require_identity_viewer(dungeon_master) is dungeon_master
    with pytest.raises(HTTPException) as raised:
        require_identity_manager(dungeon_master)

    assert raised.value.status_code == 403


def test_dungeon_master_is_a_valid_system_user_role() -> None:
    payload = UserCreate(
        username="dm-role-test",
        password="a-secure-temporary-password",
        role="dungeon_master",
        permissions=["view_accounts", "activate_cd_keys"],
    )

    assert payload.role == "dungeon_master"
    assert payload.permissions == ["view_accounts", "activate_cd_keys"]


@pytest.mark.parametrize("role", ["technical", "dungeon_master"])
def test_cd_key_activation_permission_accepts_explicit_grants(role: str) -> None:
    user = EditorUser(
        username=f"cd-key-activation-{role}",
        password_hash="unused",
        role=role,
        active=True,
        system_permissions=[
            EditorSystemPermission(permission_name="view_accounts"),
            EditorSystemPermission(permission_name="activate_cd_keys"),
        ],
    )

    assert user.permissions == ["activate_cd_keys", "view_accounts"]
    assert require_cd_key_activator(user) is user


@pytest.mark.parametrize(
    "role",
    ["admin", "technical", "dungeon_master", "editor", "collaborator"],
)
def test_cd_key_activation_permission_rejects_unassigned_users(role: str) -> None:
    user = EditorUser(
        username=f"cd-key-activation-denied-{role}",
        password_hash="unused",
        role=role,
        active=True,
    )

    assert user.permissions == []
    with pytest.raises(HTTPException) as raised:
        require_cd_key_activator(user)

    assert raised.value.status_code == 403


def test_cd_key_permission_payload_requires_identity_view_access() -> None:
    with pytest.raises(ValidationError, match="view_accounts"):
        UserUpdate(permissions=["activate_cd_keys"])

    payload = UserUpdate(permissions=["view_accounts", "activate_cd_keys"])

    assert payload.permissions == ["view_accounts", "activate_cd_keys"]


def test_only_admin_can_change_system_permissions() -> None:
    admin = EditorUser(
        username="permission-admin",
        password_hash="unused",
        role="admin",
        active=True,
    )
    technical = EditorUser(
        username="permission-technical",
        password_hash="unused",
        role="technical",
        active=True,
    )

    _require_system_permission_manager(admin, ["activate_cd_keys"], [])
    _require_system_permission_manager(technical, ["activate_cd_keys"], ["activate_cd_keys"])
    with pytest.raises(HTTPException) as raised:
        _require_system_permission_manager(technical, ["activate_cd_keys"], [])

    assert raised.value.status_code == 403


def test_non_admin_user_editor_cannot_cross_admin_profile_boundary() -> None:
    technical = EditorUser(
        username="profile-boundary-technical",
        password_hash="unused",
        role="technical",
        active=True,
    )

    with pytest.raises(HTTPException):
        _require_admin_profile_manager(technical, None, "admin")
    with pytest.raises(HTTPException):
        _require_admin_profile_manager(technical, "admin", None)


def test_user_cannot_delete_own_profile() -> None:
    actor = EditorUser(
        user_id=7,
        username="self-delete-admin",
        password_hash="unused",
        role="admin",
        active=True,
    )

    with pytest.raises(HTTPException, match="propio usuario") as raised:
        _require_user_deletion(actor, actor)

    assert raised.value.status_code == 409


def test_non_admin_cannot_delete_admin_profile() -> None:
    actor = EditorUser(
        user_id=7,
        username="delete-boundary-technical",
        password_hash="unused",
        role="technical",
        active=True,
    )
    target = EditorUser(
        user_id=8,
        username="delete-boundary-admin",
        password_hash="unused",
        role="admin",
        active=True,
    )

    with pytest.raises(HTTPException) as raised:
        _require_user_deletion(actor, target)

    assert raised.value.status_code == 403


def test_user_audit_snapshot_excludes_authentication_secrets() -> None:
    user = EditorUser(
        user_id=8,
        username="audit-safe-user",
        email="audit@example.test",
        password_hash="must-not-be-audited",
        role="editor",
        active=True,
        system_permissions=[
            EditorSystemPermission(permission_name="view_recipes"),
        ],
        profession_permissions=[
            EditorProfessionPermission(profession_id=2),
        ],
    )

    snapshot = _user_snapshot(user)

    assert snapshot["username"] == "audit-safe-user"
    assert snapshot["permissions"] == ["view_recipes"]
    assert "password_hash" not in snapshot


def test_audit_target_label_uses_stored_snapshot_name() -> None:
    assert _target_label(
        "character",
        42,
        {"display_name": "Audit Character"},
    ) == "Personaje 42 · Audit Character"


def test_user_administration_rejects_technical_role() -> None:
    technical = EditorUser(
        username="user-admin-test-technical",
        password_hash="unused",
        role="technical",
        active=True,
    )

    with pytest.raises(HTTPException) as raised:
        require_admin(technical)

    assert raised.value.status_code == 403


def test_user_management_accepts_technical_role() -> None:
    technical = EditorUser(
        username="user-manager-test-technical",
        password_hash="unused",
        role="technical",
        active=True,
        system_permissions=[
            EditorSystemPermission(permission_name="view_users"),
            EditorSystemPermission(permission_name="edit_users"),
        ],
    )

    assert require_user_manager(technical) is technical


def test_user_management_rejects_editor_role() -> None:
    editor = EditorUser(
        username="user-manager-test-editor",
        password_hash="unused",
        role="editor",
        active=True,
    )

    with pytest.raises(HTTPException) as raised:
        require_user_manager(editor)

    assert raised.value.status_code == 403


def test_user_email_is_normalized() -> None:
    payload = UserUpdate(email="  Person@Example.COM  ")

    assert payload.email == "person@example.com"


def test_user_email_can_be_cleared() -> None:
    payload = UserUpdate(email="")

    assert payload.email is None
    assert "email" in payload.model_fields_set


def test_user_email_rejects_invalid_values() -> None:
    with pytest.raises(ValidationError, match="correo electrónico no es válido"):
        UserUpdate(email="not-an-email")


def test_recipe_edit_requires_permission_and_assigned_profession() -> None:
    collaborator = EditorUser(
        username="profession-test-collaborator",
        password_hash="unused",
        role="collaborator",
        active=True,
        profession_permissions=[
            EditorProfessionPermission(profession_id=3),
            EditorProfessionPermission(profession_id=7),
        ],
        system_permissions=[
            EditorSystemPermission(permission_name="view_recipes"),
            EditorSystemPermission(permission_name="edit_recipes"),
        ],
    )

    assert can_edit_profession(collaborator, 3)
    assert can_edit_profession(collaborator, 7)
    assert not can_edit_profession(collaborator, 1)


def test_dungeon_master_cannot_edit_catalogue_professions() -> None:
    dungeon_master = EditorUser(
        username="profession-test-dungeon-master",
        password_hash="unused",
        role="dungeon_master",
        active=True,
    )

    assert not can_edit_profession(dungeon_master, 7)


@pytest.mark.parametrize("role", ["admin", "technical", "editor"])
def test_recipe_edit_is_not_derived_from_role(role: str) -> None:
    user = EditorUser(
        username=f"profession-test-{role}",
        password_hash="unused",
        role=role,
        active=True,
    )

    assert not can_edit_profession(user, 7)


def test_role_presets_form_valid_explicit_permission_sets() -> None:
    for permissions in ROLE_PERMISSION_PRESETS.values():
        assert missing_permission_dependencies(set(permissions)) == set()


def test_character_section_edit_permission_requires_matching_view_permission() -> None:
    with pytest.raises(ValidationError, match="view_character_profile"):
        UserUpdate(permissions=["edit_character_profile"])


def test_character_update_accepts_one_authorized_section() -> None:
    payload = CharacterUpdate(
        updated_at=None,
        display_name_override="Administrative Name",
        status="blocked",
    )

    assert payload.model_fields_set == {"updated_at", "display_name_override", "status"}
    assert payload.tradeskills is None


def test_collaborator_permission_payload_rejects_duplicates() -> None:
    with pytest.raises(ValidationError, match="no pueden repetirse"):
        UserCreate(
            username="duplicate-tabs",
            password="a-secure-temporary-password",
            role="collaborator",
            editable_profession_ids=[7, 7],
        )


@pytest.mark.parametrize(
    ("skill_xp", "expected_level"),
    [
        (0, 1),
        (32, 1),
        (33, 2),
        (1203, 10),
        (6499, 19),
        (6500, 20),
        (2147483647, 20),
    ],
)
def test_tradeskill_level_matches_live_xp_curve(skill_xp: int, expected_level: int) -> None:
    assert tradeskill_level_from_xp(skill_xp) == expected_level


def test_live_tradeskill_curve_has_twenty_levels() -> None:
    assert len(TRADESKILL_LEVEL_THRESHOLDS) == 20
    assert tuple(sorted(TRADESKILL_LEVEL_THRESHOLDS)) == TRADESKILL_LEVEL_THRESHOLDS


def test_character_update_requires_all_seven_tradeskills() -> None:
    payload = _character_payload()
    payload["tradeskills"] = payload["tradeskills"][:-1]

    with pytest.raises(ValidationError):
        CharacterUpdate.model_validate(payload)


def test_character_update_accepts_two_trained_professions_plus_alchemy() -> None:
    payload = _character_payload()
    for item in payload["tradeskills"]:
        if item["skill_name"] in {"Herreria", "Joyeria", "Alquimia"}:
            item["skill_xp"] = 250

    character = CharacterUpdate.model_validate(payload)

    assert len(character.tradeskills) == 7


def test_character_update_rejects_a_third_trained_non_alchemy_profession() -> None:
    payload = _character_payload()
    for item in payload["tradeskills"]:
        if item["skill_name"] in {"Herreria", "Joyeria", "Sastreria"}:
            item["skill_xp"] = 250

    with pytest.raises(ValidationError, match="solo puede tener dos oficios"):
        CharacterUpdate.model_validate(payload)


def test_character_update_accepts_a_positive_rebuild_increment() -> None:
    payload = CharacterUpdate(updated_at=None, rebuilds_added=2)

    assert payload.rebuilds_added == 2
    assert payload.model_fields_set == {"updated_at", "rebuilds_added"}


@pytest.mark.parametrize("rebuilds_added", [0, -1, REBUILDS_ADDED_MAX + 1])
def test_character_update_rejects_a_rebuild_increment_out_of_range(rebuilds_added: int) -> None:
    with pytest.raises(ValidationError):
        CharacterUpdate(updated_at=None, rebuilds_added=rebuilds_added)


def test_character_update_has_no_field_that_sets_or_lowers_rebuilds() -> None:
    for field in ("rebuilds_available", "rebuilds_completed"):
        with pytest.raises(ValidationError, match="Extra inputs are not permitted"):
            CharacterUpdate.model_validate({"updated_at": None, field: 0})


def _rebuild_database(rebuilds_available: int) -> DatabaseSession:
    engine = create_engine("sqlite+pysqlite:///:memory:")
    for table in (
        Account.__table__,
        Character.__table__,
        CharacterProfile.__table__,
        ClassDefinition.__table__,
        CharacterClass.__table__,
        Tradeskill.__table__,
        CharacterLevelUnlock.__table__,
    ):
        table.create(engine)
    # SQLite only autoincrements an INTEGER primary key, and the model's is a
    # BIGINT for MySQL, so the audit table is declared by hand here.
    with engine.begin() as connection:
        connection.exec_driver_sql(
            "CREATE TABLE pwdb_identity_revision ("
            " revision_id INTEGER PRIMARY KEY AUTOINCREMENT,"
            " target_type VARCHAR(16) NOT NULL, target_id INTEGER NOT NULL,"
            " actor_user_id INTEGER, action VARCHAR(16) NOT NULL,"
            " changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,"
            " before_json JSON NOT NULL, after_json JSON NOT NULL)"
        )
    now = datetime.now(UTC).replace(tzinfo=None)
    db = DatabaseSession(engine)
    db.add(
        Account(
            account_id=1,
            cd_key="REBUILDKEY",
            player_name="Rebuild account",
            first_seen=now,
            last_seen=now,
        )
    )
    db.add(
        Character(
            character_id=5,
            character_uuid="00000000-0000-0000-0000-000000000005",
            account_id=1,
            char_name="Rebuilt",
            created_at=now,
            rebuilds_available=rebuilds_available,
            rebuilds_completed=1,
        )
    )
    db.commit()
    return db


def _rebuild_context(*permissions: str) -> SimpleNamespace:
    return SimpleNamespace(user=SimpleNamespace(user_id=1, permissions=list(permissions)))


def test_adding_rebuilds_increments_the_stored_count_and_is_audited() -> None:
    db = _rebuild_database(rebuilds_available=0)
    context = _rebuild_context(
        "view_accounts",
        "view_characters",
        "view_character_identity",
        "edit_character_identity",
    )

    detail = update_character(
        5, CharacterUpdate(updated_at=None, rebuilds_added=2), context, db
    )

    assert detail.rebuilds_available == 2
    assert detail.rebuilds_completed == 1
    revision = db.scalar(select(IdentityRevision))
    assert revision.before_json["rebuilds_available"] == 0
    assert revision.after_json["rebuilds_available"] == 2


def test_saving_a_character_keeps_the_portrait_exactly_as_sent() -> None:
    db = _rebuild_database(rebuilds_available=0)
    context = _rebuild_context(
        "view_accounts",
        "view_characters",
        "view_character_profile",
        "edit_character_profile",
    )

    update_character(
        5, CharacterUpdate(updated_at=None, portrait_resref=" po raro "), context, db
    )

    assert db.get(CharacterProfile, 5).portrait_resref == " po raro "


def test_adding_rebuilds_requires_the_identity_edit_permission() -> None:
    db = _rebuild_database(rebuilds_available=1)
    context = _rebuild_context(
        "view_accounts",
        "view_characters",
        "view_character_identity",
    )

    with pytest.raises(HTTPException) as raised:
        update_character(5, CharacterUpdate(updated_at=None, rebuilds_added=1), context, db)

    assert raised.value.status_code == 403
    assert db.get(Character, 5).rebuilds_available == 1
