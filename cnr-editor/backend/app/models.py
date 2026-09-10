"""Control-panel-owned tables and mappings for connected systems."""

from datetime import datetime

from sqlalchemy import (
    JSON,
    BigInteger,
    Boolean,
    CheckConstraint,
    DateTime,
    ForeignKey,
    Integer,
    SmallInteger,
    String,
    Text,
    func,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base


class EditorUser(Base):
    __tablename__ = "cnr_editor_user"
    __table_args__ = (
        CheckConstraint(
            "role IN ('admin','technical','dungeon_master','editor','collaborator')",
            name="ck_editor_user_role",
        ),
    )

    user_id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    username: Mapped[str] = mapped_column(String(64), unique=True, nullable=False)
    email: Mapped[str | None] = mapped_column(String(254), unique=True)
    password_hash: Mapped[str] = mapped_column(String(255), nullable=False)
    role: Mapped[str] = mapped_column(String(16), nullable=False, default="editor")
    active: Mapped[bool] = mapped_column(Boolean, nullable=False, default=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime,
        nullable=False,
        server_default=func.current_timestamp(),
        onupdate=func.current_timestamp(),
    )

    sessions: Mapped[list["EditorSession"]] = relationship(
        back_populates="user", cascade="all, delete-orphan"
    )
    totp_credential: Mapped["EditorTotpCredential | None"] = relationship(
        back_populates="user", cascade="all, delete-orphan", uselist=False
    )
    mfa_challenges: Mapped[list["EditorMfaChallenge"]] = relationship(
        back_populates="user", cascade="all, delete-orphan"
    )
    profession_permissions: Mapped[list["EditorProfessionPermission"]] = relationship(
        back_populates="user", cascade="all, delete-orphan"
    )
    system_permissions: Mapped[list["EditorSystemPermission"]] = relationship(
        back_populates="user", cascade="all, delete-orphan"
    )

    @property
    def editable_profession_ids(self) -> list[int]:
        """Return the recipe professions explicitly assigned to the user."""
        return sorted(permission.profession_id for permission in self.profession_permissions)

    @property
    def permissions(self) -> list[str]:
        """Return the system capabilities explicitly granted to the user."""
        return sorted(permission.permission_name for permission in self.system_permissions)

    @property
    def mfa_enabled(self) -> bool:
        """Return whether the user completed TOTP enrollment."""
        return (
            self.totp_credential is not None
            and self.totp_credential.confirmed_at is not None
        )


class EditorProfessionPermission(Base):
    __tablename__ = "cnr_editor_profession_permission"
    __table_args__ = (
        CheckConstraint("profession_id > 0", name="ck_editor_permission_profession"),
    )

    user_id: Mapped[int] = mapped_column(
        ForeignKey("cnr_editor_user.user_id", ondelete="CASCADE"), primary_key=True
    )
    # Deliberately not a foreign key: the catalogue seed deletes and recreates
    # cnr_profession while keeping the same stable profession IDs.
    profession_id: Mapped[int] = mapped_column(SmallInteger, primary_key=True)

    user: Mapped[EditorUser] = relationship(back_populates="profession_permissions")


class EditorSystemPermission(Base):
    __tablename__ = "cnr_editor_system_permission"
    __table_args__ = (
        CheckConstraint(
            "permission_name IN ("
            "'view_recipes','edit_recipes','view_users','edit_users',"
            "'view_accounts','edit_accounts','activate_cd_keys','view_characters',"
            "'view_character_identity','edit_character_identity',"
            "'view_character_timestamps','view_character_abilities',"
            "'view_character_classes','view_character_level_unlocks',"
            "'edit_character_level_unlocks','view_character_profile',"
            "'edit_character_profile','view_character_tradeskills',"
            "'edit_character_tradeskills')",
            name="ck_editor_system_permission_name",
        ),
    )

    user_id: Mapped[int] = mapped_column(
        ForeignKey("cnr_editor_user.user_id", ondelete="CASCADE"), primary_key=True
    )
    permission_name: Mapped[str] = mapped_column(String(32), primary_key=True)

    user: Mapped[EditorUser] = relationship(back_populates="system_permissions")


class EditorSession(Base):
    __tablename__ = "cnr_editor_session"

    token_hash: Mapped[str] = mapped_column(String(64), primary_key=True)
    csrf_token_hash: Mapped[str] = mapped_column(String(64), nullable=False)
    user_id: Mapped[int] = mapped_column(
        ForeignKey("cnr_editor_user.user_id", ondelete="CASCADE"), nullable=False, index=True
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )
    expires_at: Mapped[datetime] = mapped_column(DateTime, nullable=False, index=True)

    user: Mapped[EditorUser] = relationship(back_populates="sessions")


class EditorTotpCredential(Base):
    __tablename__ = "cnr_editor_totp_credential"

    user_id: Mapped[int] = mapped_column(
        ForeignKey("cnr_editor_user.user_id", ondelete="CASCADE"), primary_key=True
    )
    secret_ciphertext: Mapped[str] = mapped_column(String(512), nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )
    confirmed_at: Mapped[datetime | None] = mapped_column(DateTime)
    last_used_step: Mapped[int | None] = mapped_column(BigInteger)

    user: Mapped[EditorUser] = relationship(back_populates="totp_credential")
    recovery_codes: Mapped[list["EditorMfaRecoveryCode"]] = relationship(
        back_populates="credential", cascade="all, delete-orphan"
    )


class EditorMfaRecoveryCode(Base):
    __tablename__ = "cnr_editor_mfa_recovery_code"

    user_id: Mapped[int] = mapped_column(
        ForeignKey("cnr_editor_totp_credential.user_id", ondelete="CASCADE"),
        primary_key=True,
    )
    code_hash: Mapped[str] = mapped_column(String(64), primary_key=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )
    used_at: Mapped[datetime | None] = mapped_column(DateTime)

    credential: Mapped[EditorTotpCredential] = relationship(back_populates="recovery_codes")


class EditorMfaChallenge(Base):
    __tablename__ = "cnr_editor_mfa_challenge"

    token_hash: Mapped[str] = mapped_column(String(64), primary_key=True)
    user_id: Mapped[int] = mapped_column(
        ForeignKey("cnr_editor_user.user_id", ondelete="CASCADE"), nullable=False, index=True
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )
    expires_at: Mapped[datetime] = mapped_column(DateTime, nullable=False, index=True)
    failed_attempts: Mapped[int] = mapped_column(SmallInteger, nullable=False, default=0)

    user: Mapped[EditorUser] = relationship(back_populates="mfa_challenges")


class EditorLoginThrottle(Base):
    __tablename__ = "cnr_editor_login_throttle"

    subject_hash: Mapped[str] = mapped_column(String(64), primary_key=True)
    failed_attempts: Mapped[int] = mapped_column(SmallInteger, nullable=False, default=0)
    window_started_at: Mapped[datetime] = mapped_column(DateTime, nullable=False)
    blocked_until: Mapped[datetime | None] = mapped_column(DateTime, index=True)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime,
        nullable=False,
        server_default=func.current_timestamp(),
        onupdate=func.current_timestamp(),
    )


class EditorUserRevision(Base):
    __tablename__ = "cnr_editor_user_revision"

    revision_id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    target_user_id: Mapped[int] = mapped_column(Integer, nullable=False, index=True)
    actor_user_id: Mapped[int | None] = mapped_column(
        ForeignKey("cnr_editor_user.user_id", ondelete="SET NULL"), index=True
    )
    action: Mapped[str] = mapped_column(String(16), nullable=False)
    changed_at: Mapped[datetime] = mapped_column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )
    before_json: Mapped[dict] = mapped_column(JSON, nullable=False)
    after_json: Mapped[dict] = mapped_column(JSON, nullable=False)


class Profession(Base):
    __tablename__ = "cnr_profession"

    profession_id: Mapped[int] = mapped_column(SmallInteger, primary_key=True)
    code: Mapped[str] = mapped_column(String(16), nullable=False)
    display_name: Mapped[str] = mapped_column(String(48), nullable=False)
    skill_index: Mapped[int] = mapped_column(SmallInteger, nullable=False)


class Station(Base):
    __tablename__ = "cnr_station"

    station_id: Mapped[int] = mapped_column(SmallInteger, primary_key=True)
    profession_id: Mapped[int] = mapped_column(ForeignKey("cnr_profession.profession_id"))
    tag: Mapped[str] = mapped_column(String(32), nullable=False)
    display_name: Mapped[str] = mapped_column(String(48), nullable=False)


class Category(Base):
    __tablename__ = "cnr_category"

    category_id: Mapped[int] = mapped_column(SmallInteger, primary_key=True)
    station_id: Mapped[int] = mapped_column(ForeignKey("cnr_station.station_id"))
    parent_id: Mapped[int | None] = mapped_column(ForeignKey("cnr_category.category_id"))
    display_name: Mapped[str] = mapped_column(String(48), nullable=False)
    sort_order: Mapped[int] = mapped_column(SmallInteger, nullable=False)


class Material(Base):
    __tablename__ = "cnr_material"

    material_id: Mapped[int] = mapped_column(SmallInteger, primary_key=True)
    profession_id: Mapped[int] = mapped_column(ForeignKey("cnr_profession.profession_id"))
    code: Mapped[str] = mapped_column(String(48), nullable=False)
    display_name: Mapped[str] = mapped_column(String(48), nullable=False)
    tier: Mapped[int] = mapped_column(SmallInteger, nullable=False)
    enabled: Mapped[bool] = mapped_column(Boolean, nullable=False)


class Recipe(Base):
    __tablename__ = "cnr_recipe"

    recipe_id: Mapped[int] = mapped_column(Integer, primary_key=True)
    public_id: Mapped[int] = mapped_column(Integer, nullable=False, unique=True)
    category_id: Mapped[int] = mapped_column(ForeignKey("cnr_category.category_id"))
    material_id: Mapped[int | None] = mapped_column(ForeignKey("cnr_material.material_id"))
    tier: Mapped[int] = mapped_column(SmallInteger, nullable=False)
    display_name: Mapped[str] = mapped_column(String(96), nullable=False)
    description: Mapped[str | None] = mapped_column(String(255))
    base_resref: Mapped[str] = mapped_column(String(16), nullable=False)
    output_tag: Mapped[str | None] = mapped_column(String(32))
    output_qty: Mapped[int] = mapped_column(SmallInteger, nullable=False)
    output_kind: Mapped[str] = mapped_column(String(16), nullable=False)
    dc: Mapped[int] = mapped_column(SmallInteger, nullable=False)
    xp_award: Mapped[int] = mapped_column(Integer, nullable=False)
    gold_value: Mapped[int] = mapped_column(Integer, nullable=False)
    enabled: Mapped[bool] = mapped_column(Boolean, nullable=False)
    legacy_code: Mapped[str | None] = mapped_column(String(64))
    created_at: Mapped[datetime] = mapped_column(DateTime, nullable=False)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime,
        nullable=False,
        server_default=func.current_timestamp(),
        server_onupdate=func.current_timestamp(),
    )

    components: Mapped[list["RecipeComponent"]] = relationship(
        back_populates="recipe",
        cascade="all, delete-orphan",
        order_by="RecipeComponent.sort_order",
    )
    properties: Mapped[list["RecipeProperty"]] = relationship(
        back_populates="recipe",
        cascade="all, delete-orphan",
        order_by="RecipeProperty.sort_order",
    )


class RecipeComponent(Base):
    __tablename__ = "cnr_recipe_component"

    recipe_id: Mapped[int] = mapped_column(
        ForeignKey("cnr_recipe.recipe_id", ondelete="CASCADE"), primary_key=True
    )
    component_tag: Mapped[str] = mapped_column(String(32), primary_key=True)
    display_name: Mapped[str | None] = mapped_column(String(96))
    qty: Mapped[int] = mapped_column(SmallInteger, nullable=False)
    retain_on_fail: Mapped[int] = mapped_column(SmallInteger, nullable=False)
    sort_order: Mapped[int] = mapped_column(SmallInteger, nullable=False)

    recipe: Mapped[Recipe] = relationship(back_populates="components")


class RecipeProperty(Base):
    __tablename__ = "cnr_recipe_property"

    recipe_property_id: Mapped[int] = mapped_column(Integer, primary_key=True)
    recipe_id: Mapped[int] = mapped_column(ForeignKey("cnr_recipe.recipe_id", ondelete="CASCADE"))
    property_type: Mapped[str] = mapped_column(String(32), nullable=False)
    subtype: Mapped[int] = mapped_column(Integer, nullable=False)
    value1: Mapped[int] = mapped_column(Integer, nullable=False)
    value2: Mapped[int] = mapped_column(Integer, nullable=False)
    sort_order: Mapped[int] = mapped_column(SmallInteger, nullable=False)

    recipe: Mapped[Recipe] = relationship(back_populates="properties")


class CatalogueRevision(Base):
    __tablename__ = "cnr_catalogue_revision"

    revision_id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    recipe_id: Mapped[int] = mapped_column(ForeignKey("cnr_recipe.recipe_id"), index=True)
    actor_user_id: Mapped[int | None] = mapped_column(
        ForeignKey("cnr_editor_user.user_id", ondelete="SET NULL")
    )
    action: Mapped[str] = mapped_column(String(16), nullable=False)
    changed_at: Mapped[datetime] = mapped_column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )
    before_json: Mapped[dict] = mapped_column(JSON, nullable=False)
    after_json: Mapped[dict] = mapped_column(JSON, nullable=False)
    note: Mapped[str | None] = mapped_column(Text)


class Account(Base):
    __tablename__ = "pwdb_account"

    account_id: Mapped[int] = mapped_column(Integer, primary_key=True)
    cd_key: Mapped[str] = mapped_column(String(16), nullable=False, unique=True)
    player_name: Mapped[str | None] = mapped_column(String(64))
    first_seen: Mapped[datetime] = mapped_column(DateTime, nullable=False)
    last_seen: Mapped[datetime] = mapped_column(DateTime, nullable=False)

    management: Mapped["AccountManagement | None"] = relationship(
        back_populates="account", cascade="all, delete-orphan", uselist=False
    )
    cd_key_reset: Mapped["AccountCdKeyReset | None"] = relationship(
        back_populates="account", cascade="all, delete-orphan", uselist=False
    )
    characters: Mapped[list["Character"]] = relationship(back_populates="account")


class AccountManagement(Base):
    __tablename__ = "pwdb_account_management"
    __table_args__ = (
        CheckConstraint(
            "status IN ('active','blocked')",
            name="ck_account_management_status",
        ),
    )

    account_id: Mapped[int] = mapped_column(
        ForeignKey("pwdb_account.account_id", ondelete="CASCADE"), primary_key=True
    )
    display_name_override: Mapped[str | None] = mapped_column(String(64))
    status: Mapped[str] = mapped_column(String(16), nullable=False, default="active")
    admin_notes: Mapped[str | None] = mapped_column(Text)
    updated_by: Mapped[int | None] = mapped_column(
        ForeignKey("cnr_editor_user.user_id", ondelete="SET NULL")
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime,
        nullable=False,
        server_default=func.current_timestamp(),
        server_onupdate=func.current_timestamp(),
    )

    account: Mapped[Account] = relationship(back_populates="management")


class AccountCdKeyReset(Base):
    __tablename__ = "pwdb_account_cdkey_reset"

    account_id: Mapped[int] = mapped_column(
        ForeignKey("pwdb_account.account_id", ondelete="CASCADE"), primary_key=True
    )
    candidate_cd_key: Mapped[str | None] = mapped_column(String(16), unique=True)
    requested_by: Mapped[int | None] = mapped_column(
        ForeignKey("cnr_editor_user.user_id", ondelete="SET NULL")
    )
    requested_at: Mapped[datetime] = mapped_column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )
    expires_at: Mapped[datetime] = mapped_column(DateTime, nullable=False)
    candidate_captured_at: Mapped[datetime | None] = mapped_column(DateTime)
    confirmed_by: Mapped[int | None] = mapped_column(
        ForeignKey("cnr_editor_user.user_id", ondelete="SET NULL")
    )
    confirmed_at: Mapped[datetime | None] = mapped_column(DateTime)

    account: Mapped[Account] = relationship(back_populates="cd_key_reset")


class AccountNameHistory(Base):
    __tablename__ = "pwdb_account_name_history"

    account_id: Mapped[int] = mapped_column(
        ForeignKey("pwdb_account.account_id", ondelete="CASCADE"), primary_key=True
    )
    player_name: Mapped[str] = mapped_column(String(64), primary_key=True)
    first_seen_at: Mapped[datetime] = mapped_column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )
    last_seen_at: Mapped[datetime] = mapped_column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )
    verified_count: Mapped[int] = mapped_column(BigInteger, nullable=False, default=0)


class AccountCdKeyHistory(Base):
    __tablename__ = "pwdb_account_cd_key_history"

    account_id: Mapped[int] = mapped_column(
        ForeignKey("pwdb_account.account_id", ondelete="CASCADE"), primary_key=True
    )
    cd_key: Mapped[str] = mapped_column(String(16), primary_key=True)
    first_seen_at: Mapped[datetime] = mapped_column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )
    last_seen_at: Mapped[datetime] = mapped_column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )
    attempt_count: Mapped[int] = mapped_column(BigInteger, nullable=False, default=0)
    verified_count: Mapped[int] = mapped_column(BigInteger, nullable=False, default=0)
    last_player_name: Mapped[str | None] = mapped_column(String(64))


class AccountIpHistory(Base):
    __tablename__ = "pwdb_account_ip_history"

    account_id: Mapped[int] = mapped_column(
        ForeignKey("pwdb_account.account_id", ondelete="CASCADE"), primary_key=True
    )
    ip_address: Mapped[str] = mapped_column(String(45), primary_key=True)
    first_seen_at: Mapped[datetime] = mapped_column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )
    last_seen_at: Mapped[datetime] = mapped_column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )
    attempt_count: Mapped[int] = mapped_column(BigInteger, nullable=False, default=0)
    verified_count: Mapped[int] = mapped_column(BigInteger, nullable=False, default=0)


class CdKeyBan(Base):
    __tablename__ = "pwdb_cd_key_ban"

    cd_key: Mapped[str] = mapped_column(String(16), primary_key=True)
    active: Mapped[bool] = mapped_column(Boolean, nullable=False, default=True)
    reason: Mapped[str | None] = mapped_column(String(500))
    banned_at: Mapped[datetime] = mapped_column(DateTime, nullable=False)
    unbanned_at: Mapped[datetime | None] = mapped_column(DateTime)
    updated_at: Mapped[datetime] = mapped_column(DateTime, nullable=False)


class DmCdKeyWhitelist(Base):
    __tablename__ = "pwdb_dm_cd_key_whitelist"

    cd_key: Mapped[str] = mapped_column(String(16), primary_key=True)
    display_name: Mapped[str | None] = mapped_column(String(64))
    added_at: Mapped[datetime] = mapped_column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )


class DmCdKeyWhitelistRevision(Base):
    __tablename__ = "pwdb_dm_cd_key_whitelist_revision"

    revision_id: Mapped[int] = mapped_column(
        BigInteger().with_variant(Integer, "sqlite"),
        primary_key=True,
        autoincrement=True,
    )
    cd_key: Mapped[str] = mapped_column(String(16), nullable=False, index=True)
    actor_user_id: Mapped[int | None] = mapped_column(
        ForeignKey("cnr_editor_user.user_id", ondelete="SET NULL"), index=True
    )
    action: Mapped[str] = mapped_column(String(16), nullable=False)
    changed_at: Mapped[datetime] = mapped_column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )
    before_json: Mapped[dict] = mapped_column(JSON, nullable=False)
    after_json: Mapped[dict] = mapped_column(JSON, nullable=False)


class Character(Base):
    __tablename__ = "pwdb_character"
    __table_args__ = (
        CheckConstraint(
            "rebuilds_available >= 0",
            name="ck_character_rebuilds_available",
        ),
        CheckConstraint(
            "rebuilds_completed >= 0",
            name="ck_character_rebuilds_completed",
        ),
    )

    character_id: Mapped[int] = mapped_column(Integer, primary_key=True)
    character_uuid: Mapped[str] = mapped_column(String(36), nullable=False, unique=True)
    account_id: Mapped[int] = mapped_column(ForeignKey("pwdb_account.account_id"), nullable=False)
    char_name: Mapped[str | None] = mapped_column(String(64))
    created_at: Mapped[datetime] = mapped_column(DateTime, nullable=False)
    last_login_at: Mapped[datetime | None] = mapped_column(DateTime)
    rebuilds_available: Mapped[int] = mapped_column(
        SmallInteger, nullable=False, default=2, server_default="2"
    )
    rebuilds_completed: Mapped[int] = mapped_column(
        Integer, nullable=False, default=0, server_default="0"
    )

    account: Mapped[Account] = relationship(back_populates="characters")
    profile: Mapped["CharacterProfile | None"] = relationship(
        back_populates="character", cascade="all, delete-orphan", uselist=False
    )
    classes: Mapped[list["CharacterClass"]] = relationship(
        back_populates="character",
        cascade="all, delete-orphan",
        order_by="CharacterClass.class_slot",
    )
    tradeskills: Mapped[list["Tradeskill"]] = relationship(
        back_populates="character",
        order_by="Tradeskill.skill_name",
    )
    level_unlocks: Mapped[list["CharacterLevelUnlock"]] = relationship(
        back_populates="character",
        cascade="all, delete-orphan",
        order_by="CharacterLevelUnlock.unlock_level",
    )


class CharacterLevelUnlock(Base):
    __tablename__ = "pwdb_character_level_unlock"
    __table_args__ = (
        CheckConstraint(
            "unlock_level IN (9,13,17,21,22,24,26,30,35)",
            name="ck_character_level_unlock_level",
        ),
    )

    character_id: Mapped[int] = mapped_column(
        ForeignKey("pwdb_character.character_id", ondelete="CASCADE"), primary_key=True
    )
    unlock_level: Mapped[int] = mapped_column(SmallInteger, primary_key=True)
    granted_by: Mapped[int | None] = mapped_column(
        ForeignKey("cnr_editor_user.user_id", ondelete="SET NULL")
    )
    granted_at: Mapped[datetime] = mapped_column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )

    character: Mapped[Character] = relationship(back_populates="level_unlocks")


class Tradeskill(Base):
    __tablename__ = "cnr_tradeskill"

    character_id: Mapped[int] = mapped_column(
        ForeignKey("pwdb_character.character_id", ondelete="CASCADE"), primary_key=True
    )
    skill_name: Mapped[str] = mapped_column(String(32), primary_key=True)
    skill_level: Mapped[int] = mapped_column(Integer, nullable=False)
    skill_xp: Mapped[int] = mapped_column(Integer, nullable=False)
    updated_at: Mapped[datetime] = mapped_column(DateTime, nullable=False)

    character: Mapped[Character] = relationship(back_populates="tradeskills")


class CharacterProfile(Base):
    __tablename__ = "pwdb_character_profile"
    __table_args__ = (
        CheckConstraint(
            "status IN ('active','blocked','deleted')",
            name="ck_character_profile_status",
        ),
        CheckConstraint(
            "strength_score BETWEEN 0 AND 255",
            name="ck_character_profile_strength",
        ),
        CheckConstraint(
            "dexterity_score BETWEEN 0 AND 255",
            name="ck_character_profile_dexterity",
        ),
        CheckConstraint(
            "constitution_score BETWEEN 0 AND 255",
            name="ck_character_profile_constitution",
        ),
        CheckConstraint(
            "intelligence_score BETWEEN 0 AND 255",
            name="ck_character_profile_intelligence",
        ),
        CheckConstraint(
            "wisdom_score BETWEEN 0 AND 255",
            name="ck_character_profile_wisdom",
        ),
        CheckConstraint(
            "charisma_score BETWEEN 0 AND 255",
            name="ck_character_profile_charisma",
        ),
    )

    character_id: Mapped[int] = mapped_column(
        ForeignKey("pwdb_character.character_id", ondelete="CASCADE"), primary_key=True
    )
    display_name_override: Mapped[str | None] = mapped_column(String(64))
    status: Mapped[str] = mapped_column(String(16), nullable=False, default="active")
    race_id: Mapped[int | None] = mapped_column(SmallInteger)
    subrace: Mapped[str | None] = mapped_column(String(32))
    gender_id: Mapped[int | None] = mapped_column(SmallInteger)
    portrait_resref: Mapped[str | None] = mapped_column(String(16))
    deity: Mapped[str | None] = mapped_column(String(64))
    strength_score: Mapped[int | None] = mapped_column(SmallInteger)
    dexterity_score: Mapped[int | None] = mapped_column(SmallInteger)
    constitution_score: Mapped[int | None] = mapped_column(SmallInteger)
    intelligence_score: Mapped[int | None] = mapped_column(SmallInteger)
    wisdom_score: Mapped[int | None] = mapped_column(SmallInteger)
    charisma_score: Mapped[int | None] = mapped_column(SmallInteger)
    snapshot_captured_at: Mapped[datetime | None] = mapped_column(DateTime)
    admin_notes: Mapped[str | None] = mapped_column(Text)
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime)
    name_reuse_unlocked_at: Mapped[datetime | None] = mapped_column(DateTime)
    name_reuse_unlocked_by: Mapped[int | None] = mapped_column(
        ForeignKey("cnr_editor_user.user_id", ondelete="SET NULL")
    )
    updated_by: Mapped[int | None] = mapped_column(
        ForeignKey("cnr_editor_user.user_id", ondelete="SET NULL")
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime,
        nullable=False,
        server_default=func.current_timestamp(),
        server_onupdate=func.current_timestamp(),
    )

    character: Mapped[Character] = relationship(back_populates="profile")


class ClassDefinition(Base):
    __tablename__ = "pwdb_class_definition"

    class_id: Mapped[int] = mapped_column(SmallInteger, primary_key=True, autoincrement=False)
    code: Mapped[str] = mapped_column(String(32), nullable=False)
    display_name: Mapped[str] = mapped_column(String(64), nullable=False)
    enabled: Mapped[bool] = mapped_column(Boolean, nullable=False, default=True)


class CharacterClass(Base):
    __tablename__ = "pwdb_character_class"
    __table_args__ = (
        CheckConstraint("class_slot BETWEEN 1 AND 3", name="ck_character_class_slot"),
        CheckConstraint("class_level BETWEEN 1 AND 40", name="ck_character_class_level"),
    )

    character_id: Mapped[int] = mapped_column(
        ForeignKey("pwdb_character.character_id", ondelete="CASCADE"), primary_key=True
    )
    class_slot: Mapped[int] = mapped_column(SmallInteger, primary_key=True)
    class_id: Mapped[int] = mapped_column(ForeignKey("pwdb_class_definition.class_id"))
    class_level: Mapped[int] = mapped_column(SmallInteger, nullable=False)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime,
        nullable=False,
        server_default=func.current_timestamp(),
        server_onupdate=func.current_timestamp(),
    )

    character: Mapped[Character] = relationship(back_populates="classes")
    definition: Mapped[ClassDefinition] = relationship()


class IdentityRevision(Base):
    __tablename__ = "pwdb_identity_revision"
    __table_args__ = (
        CheckConstraint(
            "target_type IN ('account','character')", name="ck_identity_revision_target"
        ),
    )

    revision_id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    target_type: Mapped[str] = mapped_column(String(16), nullable=False)
    target_id: Mapped[int] = mapped_column(Integer, nullable=False)
    actor_user_id: Mapped[int | None] = mapped_column(
        ForeignKey("cnr_editor_user.user_id", ondelete="SET NULL")
    )
    action: Mapped[str] = mapped_column(String(16), nullable=False)
    changed_at: Mapped[datetime] = mapped_column(
        DateTime, nullable=False, server_default=func.current_timestamp()
    )
    before_json: Mapped[dict] = mapped_column(JSON, nullable=False)
    after_json: Mapped[dict] = mapped_column(JSON, nullable=False)
