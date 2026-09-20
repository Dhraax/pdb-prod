"""Validated request and response contracts for the Control Panel."""

import re
from datetime import datetime
from typing import Literal

from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

from app.permissions import missing_permission_dependencies
from app.property_definitions import validate_property_values
from app.tradeskills import TRADESKILL_NAMES, tradeskill_level_from_xp

RoleName = Literal["admin", "technical", "dungeon_master", "editor", "collaborator"]
PermissionName = Literal[
    "view_recipes",
    "edit_recipes",
    "view_users",
    "edit_users",
    "view_accounts",
    "edit_accounts",
    "activate_cd_keys",
    "view_characters",
    "view_character_identity",
    "edit_character_identity",
    "view_character_timestamps",
    "view_character_abilities",
    "view_character_classes",
    "view_character_level_unlocks",
    "edit_character_level_unlocks",
    "view_character_profile",
    "edit_character_profile",
    "view_character_tradeskills",
    "edit_character_tradeskills",
]
AccountStatus = Literal["active", "blocked"]
CharacterStatus = Literal["active", "blocked", "deleted"]
CdKeyResetStatus = Literal[
    "none",
    "awaiting_candidate",
    "awaiting_confirmation",
    "confirmed",
    "expired",
]
LEVEL_UNLOCKS = (9, 13, 17, 21, 22, 24, 26, 30, 35)
EMAIL_PATTERN = re.compile(r"^[^@\s]+@[^@\s]+\.[^@\s]+$")


def _normalize_email(value: object) -> object:
    """Normalize optional email input while allowing an explicit empty value to clear it."""
    if not isinstance(value, str):
        return value
    normalized = value.strip().lower()
    return normalized or None


class LoginRequest(BaseModel):
    username: str = Field(min_length=1, max_length=64)
    password: str = Field(min_length=1, max_length=256)


class UserOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    user_id: int
    username: str
    email: str | None
    role: RoleName
    permissions: list[PermissionName]
    editable_profession_ids: list[int]
    active: bool
    mfa_enabled: bool
    created_at: datetime
    updated_at: datetime


class SessionOut(BaseModel):
    user: UserOut
    writes_enabled: bool


class MfaChallengeOut(BaseModel):
    mfa_required: Literal[True] = True


class MfaVerifyRequest(BaseModel):
    code: str = Field(min_length=6, max_length=32)


class MfaSetupRequest(BaseModel):
    password: str = Field(min_length=1, max_length=256)


class MfaSetupOut(BaseModel):
    secret: str
    provisioning_uri: str
    qr_svg_data_uri: str


class MfaConfirmRequest(BaseModel):
    code: str = Field(min_length=6, max_length=6, pattern=r"^\d{6}$")


class MfaConfirmOut(BaseModel):
    recovery_codes: list[str]


class MfaDisableRequest(BaseModel):
    password: str = Field(min_length=1, max_length=256)
    code: str = Field(min_length=6, max_length=32)


class UserCreate(BaseModel):
    username: str = Field(min_length=3, max_length=64, pattern=r"^[A-Za-z0-9_.-]+$")
    email: str | None = Field(default=None, min_length=3, max_length=254)
    password: str = Field(min_length=12, max_length=256)
    role: RoleName = "editor"
    editable_profession_ids: list[int] = Field(default_factory=list, max_length=64)
    permissions: list[PermissionName] = Field(default_factory=list, max_length=32)
    active: bool = True

    @field_validator("email", mode="before")
    @classmethod
    def normalize_email(cls, value: object) -> object:
        return _normalize_email(value)

    @field_validator("email")
    @classmethod
    def email_must_be_valid(cls, value: str | None) -> str | None:
        if value is not None and not EMAIL_PATTERN.fullmatch(value):
            raise ValueError("el correo electrónico no es válido")
        return value

    @field_validator("editable_profession_ids")
    @classmethod
    def profession_ids_must_be_unique_and_positive(cls, values: list[int]) -> list[int]:
        if any(value <= 0 or value > 65535 for value in values):
            raise ValueError("los oficios asignados no son válidos")
        if len(values) != len(set(values)):
            raise ValueError("los oficios asignados no pueden repetirse")
        return values

    @field_validator("permissions")
    @classmethod
    def permissions_must_be_unique(cls, values: list[PermissionName]) -> list[PermissionName]:
        if len(values) != len(set(values)):
            raise ValueError("los permisos del sistema no pueden repetirse")
        missing = missing_permission_dependencies(set(values))
        if missing:
            raise ValueError("faltan permisos requeridos: " + ", ".join(sorted(missing)))
        return values


class UserUpdate(BaseModel):
    username: str | None = Field(
        default=None,
        min_length=3,
        max_length=64,
        pattern=r"^[A-Za-z0-9_.-]+$",
    )
    email: str | None = Field(default=None, min_length=3, max_length=254)
    role: RoleName | None = None
    editable_profession_ids: list[int] | None = Field(default=None, max_length=64)
    permissions: list[PermissionName] | None = Field(default=None, max_length=32)
    active: bool | None = None
    password: str | None = Field(default=None, min_length=12, max_length=256)

    @field_validator("email", mode="before")
    @classmethod
    def normalize_email(cls, value: object) -> object:
        return _normalize_email(value)

    @field_validator("email")
    @classmethod
    def email_must_be_valid(cls, value: str | None) -> str | None:
        if value is not None and not EMAIL_PATTERN.fullmatch(value):
            raise ValueError("el correo electrónico no es válido")
        return value

    @field_validator("editable_profession_ids")
    @classmethod
    def profession_ids_must_be_unique_and_positive(
        cls, values: list[int] | None
    ) -> list[int] | None:
        if values is None:
            return values
        if any(value <= 0 or value > 65535 for value in values):
            raise ValueError("los oficios asignados no son válidos")
        if len(values) != len(set(values)):
            raise ValueError("los oficios asignados no pueden repetirse")
        return values

    @field_validator("permissions")
    @classmethod
    def permissions_must_be_unique(
        cls, values: list[PermissionName] | None
    ) -> list[PermissionName] | None:
        if values is not None and len(values) != len(set(values)):
            raise ValueError("los permisos del sistema no pueden repetirse")
        if values is not None:
            missing = missing_permission_dependencies(set(values))
            if missing:
                raise ValueError("faltan permisos requeridos: " + ", ".join(sorted(missing)))
        return values


class AuditEntry(BaseModel):
    revision_key: str
    domain: Literal[
        "recipe", "arcane", "arcane_group", "account", "character", "user", "dm_access"
    ]
    target_id: int | str
    target_label: str
    action: str
    changed_at: datetime
    actor_user_id: int | None
    actor_username: str | None
    before: dict[str, object]
    after: dict[str, object]
    note: str | None = None


class AuditPage(BaseModel):
    items: list[AuditEntry]
    total: int
    offset: int
    limit: int
    # True when the history was longer than the window the search scanned, so
    # the page can say the count is a floor rather than quietly under-report.
    truncated: bool = False


class ComponentIn(BaseModel):
    component_tag: str = Field(min_length=1, max_length=32)
    display_name: str | None = Field(default=None, max_length=96)
    qty: int = Field(ge=1, le=32767)
    retain_on_fail: int = Field(ge=0, le=32767)
    sort_order: int = Field(ge=0, le=255)

    @model_validator(mode="after")
    def retained_quantity_must_fit(self) -> "ComponentIn":
        if self.retain_on_fail > self.qty:
            raise ValueError("la cantidad conservada al fallar no puede superar la cantidad total")
        return self


class ComponentOut(ComponentIn):
    model_config = ConfigDict(from_attributes=True)


class PropertyIn(BaseModel):
    property_type: str = Field(min_length=1, max_length=32)
    subtype: int
    value1: int
    value2: int
    sort_order: int = Field(ge=0, le=255)

    @model_validator(mode="after")
    def values_must_match_definition(self) -> "PropertyIn":
        validate_property_values(
            self.property_type,
            self.subtype,
            self.value1,
            self.value2,
        )
        return self


class PropertyOut(PropertyIn):
    model_config = ConfigDict(from_attributes=True)

    recipe_property_id: int
    display_text: str


class RecipeListItem(BaseModel):
    recipe_id: int
    public_id: int
    display_name: str
    profession_id: int
    profession_name: str
    station_name: str
    category_name: str
    material_name: str | None
    tier: int
    dc: int
    xp_award: int
    gold_value: int
    enabled: bool
    component_count: int
    property_count: int
    updated_at: datetime


class RecipeListPage(BaseModel):
    items: list[RecipeListItem]
    total: int
    offset: int
    limit: int


class RecipeDetail(BaseModel):
    recipe_id: int
    public_id: int
    category_id: int
    material_id: int | None
    tier: int
    display_name: str
    description: str | None
    base_resref: str
    output_tag: str | None
    output_qty: int
    output_kind: Literal["product", "material"]
    dc: int
    xp_award: int
    gold_value: int
    enabled: bool
    legacy_code: str | None
    created_at: datetime
    updated_at: datetime
    components: list[ComponentOut]
    properties: list[PropertyOut]


class RecipeUpdate(BaseModel):
    updated_at: datetime
    public_id: int = Field(ge=1, le=16777215)
    category_id: int = Field(ge=1, le=65535)
    material_id: int | None = Field(default=None, ge=1, le=65535)
    tier: int = Field(ge=1, le=4)
    display_name: str = Field(min_length=1, max_length=96)
    description: str | None = Field(default=None, max_length=255)
    base_resref: str = Field(min_length=1, max_length=16, pattern=r"^[A-Za-z0-9_]+$")
    output_tag: str | None = Field(default=None, max_length=32)
    output_qty: int = Field(ge=1, le=32767)
    output_kind: Literal["product", "material"]
    dc: int = Field(ge=1, le=32767)
    xp_award: int = Field(ge=0, le=16777215)
    gold_value: int = Field(ge=0, le=16777215)
    enabled: bool
    components: list[ComponentIn] = Field(min_length=1)
    properties: list[PropertyIn] = Field(default_factory=list)

    @model_validator(mode="after")
    def component_tags_must_be_unique(self) -> "RecipeUpdate":
        tags = [component.component_tag.casefold() for component in self.components]
        if len(tags) != len(set(tags)):
            raise ValueError("las etiquetas de los componentes deben ser únicas")
        return self


# ---------------------------------------------------------------------------
# Arcane enchanting.
#
# The arcane trade has no recipes and never had any: cnr_recipe is empty for
# profession 6, and the panel showed the tab as "0 recetas encontradas" because
# that was literally true. What it has instead is a property the player buys by
# the step, on an item the group admits, paying essences and crystals. These
# schemas expose that shape.
#
# The property vocabulary here is NOT the one PROPERTY_DEFINITIONS validates.
# Sixteen of the twenty-five arcane property types are unknown to that table,
# and eighteen shipped steps of types it does know would be rejected by it, so
# applying it would refuse to load data the game already runs. Validation here
# is structural; the design vocabulary is owned by documentation/oficios/
# arcano.json and enforced by migration/build_arcane.py.
# ---------------------------------------------------------------------------


class ArcaneStepIn(BaseModel):
    essences: int = Field(ge=1, le=255)
    subtype: int | None = Field(default=None, ge=0, le=2147483647)
    value1: int = Field(ge=-2147483648, le=2147483647)
    value2: int = Field(ge=-2147483648, le=2147483647)
    # cnr_arcane_step.xp is a signed MEDIUMINT, so 8388607 is the ceiling. A
    # wider bound here would pass validation and fail at the database, and the
    # caller would be told the catalogue rejected it rather than what was wrong.
    xp: int = Field(ge=0, le=8388607)
    display_value: str = Field(min_length=1, max_length=32)


class ArcaneStepOut(ArcaneStepIn):
    model_config = ConfigDict(from_attributes=True)


class ArcaneBaseItemOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    base_item: int
    crystal_cost: int


class ArcaneGroupOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    group_id: int
    code: str
    display_name: str
    any_base: bool
    bases: list[ArcaneBaseItemOut]


class ArcaneListItem(BaseModel):
    arcane_id: int
    display_name: str
    section: str
    group_id: int
    group_name: str
    any_base: bool
    tier: int
    min_level: int
    dc: int
    property_type: str
    subtype: int
    essence_name: str
    crystal_name: str
    supported: bool
    step_count: int
    base_item_count: int
    fingerprint: str


class ArcaneListPage(BaseModel):
    items: list[ArcaneListItem]
    total: int
    offset: int
    limit: int


class ArcaneDetail(BaseModel):
    arcane_id: int
    section: str
    display_name: str
    group_id: int
    tier: int
    essence_resref: str
    essence_name: str
    crystal_resref: str
    crystal_name: str
    ubicacion: str
    property_type: str
    subtype: int
    min_level: int
    dc: int
    supported: bool
    note: str | None
    group: ArcaneGroupOut
    steps: list[ArcaneStepOut]
    # The arcane tables are generated and carry no updated_at, so the
    # concurrency token is a digest of the row and its steps. Same guarantee as
    # the recipe editor's timestamp, without adding a column to a table the
    # catalogue rebuild drops.
    fingerprint: str


class ArcaneUpdate(BaseModel):
    fingerprint: str = Field(min_length=16, max_length=64)
    section: str = Field(min_length=1, max_length=32)
    display_name: str = Field(min_length=1, max_length=96)
    group_id: int = Field(ge=1, le=65535)
    tier: int = Field(ge=1, le=4)
    essence_resref: str = Field(min_length=1, max_length=16, pattern=r"^[A-Za-z0-9_]+$")
    essence_name: str = Field(min_length=1, max_length=96)
    crystal_resref: str = Field(min_length=1, max_length=16, pattern=r"^[A-Za-z0-9_]+$")
    crystal_name: str = Field(min_length=1, max_length=96)
    ubicacion: str = Field(default="", max_length=96)
    property_type: str = Field(min_length=1, max_length=32)
    subtype: int = Field(ge=0, le=2147483647)
    min_level: int = Field(ge=1, le=20)
    dc: int = Field(ge=1, le=100)
    supported: bool
    note: str | None = Field(default=None, max_length=255)
    steps: list[ArcaneStepIn] = Field(min_length=1, max_length=64)

    @model_validator(mode="after")
    def steps_must_be_unique_and_ordered(self) -> "ArcaneUpdate":
        amounts = [step.essences for step in self.steps]
        if len(amounts) != len(set(amounts)):
            raise ValueError("cada escalón debe pedir un número de esencias distinto")
        return self


class ArcaneBaseItemIn(BaseModel):
    # A BASE_ITEM_* value. The range is the 2DA's, not a guess: baseitems.2da
    # has 539 rows and row 0 is a valid one, the short sword.
    base_item: int = Field(ge=0, le=32767)
    crystal_cost: int = Field(ge=1, le=255)


class ArcaneBaseItemLabel(BaseModel):
    base_item: int
    label: str


class ArcaneGroupDetail(BaseModel):
    group_id: int
    code: str
    display_name: str
    any_base: bool
    bases: list[ArcaneBaseItemOut]
    property_count: int
    fingerprint: str


class ArcaneGroupUpdate(BaseModel):
    fingerprint: str = Field(min_length=16, max_length=64)
    display_name: str = Field(min_length=1, max_length=96)
    any_base: bool
    bases: list[ArcaneBaseItemIn] = Field(default_factory=list, max_length=512)

    @model_validator(mode="after")
    def bases_must_be_unique_and_present(self) -> "ArcaneGroupUpdate":
        items = [base.base_item for base in self.bases]
        if len(items) != len(set(items)):
            raise ValueError("cada tipo base sólo puede aparecer una vez en el grupo")
        # any_base means the join table is not read at all, so an empty list is
        # correct there and only there. Without it, a group admitting nothing
        # would silently make every property pointing at it unusable.
        if not self.any_base and not self.bases:
            raise ValueError(
                "un grupo que no admite cualquier objeto debe listar al menos un tipo base"
            )
        return self


class ArcaneReferenceData(BaseModel):
    groups: list[ArcaneGroupOut]
    sections: list[str]
    property_types: list[str]
    base_item_labels: list[ArcaneBaseItemLabel]


class ReferenceItem(BaseModel):
    id: int
    display_name: str
    parent_id: int | None = None
    profession_id: int | None = None
    station_id: int | None = None
    tier: int | None = None
    enabled: bool | None = None


class ReferenceData(BaseModel):
    professions: list[ReferenceItem]
    stations: list[ReferenceItem]
    categories: list[ReferenceItem]
    materials: list[ReferenceItem]


class PropertyOptionOut(BaseModel):
    label: str
    values: dict[str, int]


class PropertyControlOut(BaseModel):
    key: str
    label: str
    kind: Literal["select", "number"]
    bindings: list[Literal["subtype", "value1", "value2"]]
    options: list[PropertyOptionOut] = Field(default_factory=list)
    minimum: int | None = None
    maximum: int | None = None


class PropertyDefinitionOut(BaseModel):
    property_type: str
    label: str
    description: str
    defaults: dict[str, int]
    fixed: dict[str, int]
    controls: list[PropertyControlOut]


class PropertyDefinitionsOut(BaseModel):
    version: int
    items: list[PropertyDefinitionOut]


class CharacterClassOut(BaseModel):
    class_slot: int = Field(ge=1, le=3)
    class_id: int = Field(ge=0, le=65535)
    class_level: int = Field(ge=1, le=40)
    code: str
    display_name: str


class ClassDefinitionOut(BaseModel):
    class_id: int
    code: str
    display_name: str


class TradeskillIn(BaseModel):
    skill_name: str = Field(min_length=1, max_length=32)
    skill_xp: int = Field(ge=0, le=2147483647)
    updated_at: datetime | None


class TradeskillOut(TradeskillIn):
    display_name: str
    skill_level: int = Field(ge=1, le=20)
    updated_at: datetime | None


class TradeskillDefinitionOut(BaseModel):
    skill_name: str
    display_name: str
    level_thresholds: list[int]


class CharacterDetail(BaseModel):
    character_id: int
    account_id: int
    character_uuid: str | None
    observed_name: str | None
    display_name: str
    display_name_override: str | None
    status: CharacterStatus | None
    race_id: int | None
    subrace: str | None
    gender_id: int | None
    portrait_resref: str | None
    deity: str | None
    strength_score: int | None = Field(default=None, ge=0, le=255)
    dexterity_score: int | None = Field(default=None, ge=0, le=255)
    constitution_score: int | None = Field(default=None, ge=0, le=255)
    intelligence_score: int | None = Field(default=None, ge=0, le=255)
    wisdom_score: int | None = Field(default=None, ge=0, le=255)
    charisma_score: int | None = Field(default=None, ge=0, le=255)
    admin_notes: str | None
    deleted_at: datetime | None = None
    created_at: datetime | None
    last_login_at: datetime | None
    updated_at: datetime | None
    rebuilds_available: int | None = Field(default=None, ge=0)
    rebuilds_completed: int | None = Field(default=None, ge=0)
    total_level: int
    classes: list[CharacterClassOut]
    tradeskills: list[TradeskillOut]
    level_unlocks: list[int]
    applied_level_unlocks: list[int]


class AccountListItem(BaseModel):
    account_id: int
    cd_key_hint: str
    cd_key: str | None = None
    observed_name: str | None
    display_name: str
    status: AccountStatus
    character_count: int
    first_seen: datetime
    last_seen: datetime


class AccountListPage(BaseModel):
    items: list[AccountListItem]
    total: int
    offset: int
    limit: int


class AccountCdKeyResetState(BaseModel):
    model_config = ConfigDict(extra="forbid")

    status: CdKeyResetStatus
    candidate_hint: str | None = None
    requested_at: datetime | None = None
    expires_at: datetime | None = None
    candidate_captured_at: datetime | None = None
    confirmed_at: datetime | None = None


class AccountDetail(BaseModel):
    account_id: int
    cd_key_hint: str
    cd_key: str | None = None
    observed_name: str | None
    display_name: str
    display_name_override: str | None
    status: AccountStatus
    admin_notes: str | None
    first_seen: datetime
    last_seen: datetime
    updated_at: datetime | None
    cd_key_reset: AccountCdKeyResetState
    characters: list[CharacterDetail]


class AccountAccessCdKey(BaseModel):
    cd_key: str
    is_primary: bool
    first_seen_at: datetime
    last_seen_at: datetime
    attempt_count: int = Field(ge=0)
    verified_count: int = Field(ge=0)
    last_player_name: str | None
    banned: bool
    ban_reason: str | None
    banned_at: datetime | None
    unbanned_at: datetime | None


class AccountAccessIp(BaseModel):
    ip_address: str
    first_seen_at: datetime
    last_seen_at: datetime
    attempt_count: int = Field(ge=0)
    verified_count: int = Field(ge=0)


class AccountAccessHistory(BaseModel):
    cd_keys: list[AccountAccessCdKey]
    ip_addresses: list[AccountAccessIp]


class CdKeyBanUpdate(BaseModel):
    model_config = ConfigDict(extra="forbid")

    reason: str | None = Field(default=None, max_length=500)


class DmCdKeyWhitelistCreate(BaseModel):
    model_config = ConfigDict(extra="forbid")

    cd_key: str = Field(min_length=1, max_length=16, pattern=r"^[A-Za-z0-9]+$")
    display_name: str | None = Field(default=None, max_length=64)

    @field_validator("cd_key", mode="before")
    @classmethod
    def normalize_cd_key(cls, value: object) -> object:
        if isinstance(value, str):
            return value.strip().upper()
        return value

    @field_validator("display_name")
    @classmethod
    def normalize_display_name(cls, value: str | None) -> str | None:
        if value is None:
            return None
        normalized = value.strip()
        return normalized or None


class DmCdKeyWhitelistOut(BaseModel):
    cd_key: str
    display_name: str | None
    added_at: datetime
    globally_banned: bool


class AccountUpdate(BaseModel):
    updated_at: datetime | None
    display_name_override: str | None = Field(default=None, max_length=64)
    status: AccountStatus
    admin_notes: str | None = Field(default=None, max_length=4000)


class CharacterUpdate(BaseModel):
    model_config = ConfigDict(extra="forbid")

    updated_at: datetime | None
    account_id: int | None = Field(default=None, ge=1)
    display_name_override: str | None = Field(default=None, max_length=64)
    status: CharacterStatus | None = None
    race_id: int | None = Field(default=None, ge=0, le=65535)
    subrace: str | None = Field(default=None, max_length=32)
    gender_id: int | None = Field(default=None, ge=0, le=65535)
    portrait_resref: str | None = Field(
        default=None,
        max_length=16,
        pattern=r"^[A-Za-z0-9_]+$",
    )
    deity: str | None = Field(default=None, max_length=64)
    admin_notes: str | None = Field(default=None, max_length=4000)
    tradeskills: list[TradeskillIn] | None = Field(default=None, min_length=7, max_length=7)
    level_unlocks: list[int] | None = Field(default=None, max_length=len(LEVEL_UNLOCKS))

    @field_validator("level_unlocks")
    @classmethod
    def level_unlocks_must_be_known_and_unique(cls, values: list[int] | None) -> list[int] | None:
        if values is None:
            return values
        if len(values) != len(set(values)):
            raise ValueError("los desbloqueos de nivel no pueden repetirse")
        if not set(values).issubset(LEVEL_UNLOCKS):
            raise ValueError("el desbloqueo de nivel no existe en el módulo")
        return sorted(values)

    @model_validator(mode="after")
    def tradeskills_must_form_a_valid_selection(self) -> "CharacterUpdate":
        if self.tradeskills is None:
            return self
        tradeskill_names = [item.skill_name for item in self.tradeskills]
        if len(tradeskill_names) != len(set(tradeskill_names)):
            raise ValueError("un personaje no puede repetir el mismo oficio")
        if set(tradeskill_names) != set(TRADESKILL_NAMES):
            raise ValueError("el personaje debe incluir exactamente los siete oficios configurados")
        trained_professions = [
            item
            for item in self.tradeskills
            if item.skill_name != "Alquimia"
            and tradeskill_level_from_xp(item.skill_xp) >= 2
        ]
        if len(trained_professions) > 2:
            raise ValueError(
                "un personaje solo puede tener dos oficios de nivel 2 o superior; "
                "Alquimia no ocupa plaza"
            )
        return self


class CharacterPurgeRequest(BaseModel):
    model_config = ConfigDict(extra="forbid")

    updated_at: datetime
    confirmation: Literal["ELIMINAR"]
