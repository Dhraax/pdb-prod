"""Expand explicit permissions across every control-panel domain."""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0014_integral_permissions"
down_revision: str | None = "0013_system_user_permissions"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None

PERMISSION_NAMES = (
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
)
ROLE_PERMISSION_PRESETS = {
    "admin": tuple(name for name in PERMISSION_NAMES if name != "activate_cd_keys"),
    "technical": PERMISSION_NAMES,
    "dungeon_master": tuple(
        name
        for name in PERMISSION_NAMES
        if name.startswith("view_") or name == "activate_cd_keys"
    ),
    "editor": ("view_recipes", "edit_recipes"),
    "collaborator": ("view_recipes", "edit_recipes"),
}


def _drop_permission_check_if_present() -> None:
    checks = {
        check["name"]
        for check in sa.inspect(op.get_bind()).get_check_constraints(
            "cnr_editor_system_permission"
        )
    }
    if "ck_editor_system_permission_name" in checks:
        op.drop_constraint(
            "ck_editor_system_permission_name",
            "cnr_editor_system_permission",
            type_="check",
        )


def _permission_check(permission_names: tuple[str, ...]) -> str:
    values = ",".join(f"'{permission_name}'" for permission_name in permission_names)
    return f"permission_name IN ({values})"


def upgrade() -> None:
    _drop_permission_check_if_present()
    op.create_check_constraint(
        "ck_editor_system_permission_name",
        "cnr_editor_system_permission",
        _permission_check(PERMISSION_NAMES),
    )

    for role, permission_names in ROLE_PERMISSION_PRESETS.items():
        for permission_name in permission_names:
            op.execute(
                "INSERT IGNORE INTO cnr_editor_system_permission "
                "(user_id, permission_name) "
                f"SELECT user_id, '{permission_name}' FROM cnr_editor_user "
                f"WHERE role = '{role}'"
            )

    op.execute(
        "INSERT IGNORE INTO cnr_editor_profession_permission (user_id, profession_id) "
        "SELECT u.user_id, p.profession_id FROM cnr_editor_user u "
        "CROSS JOIN cnr_profession p "
        "WHERE u.role IN ('admin', 'technical', 'editor')"
    )


def downgrade() -> None:
    op.execute(
        "DELETE FROM cnr_editor_system_permission "
        "WHERE permission_name <> 'activate_cd_keys'"
    )
    _drop_permission_check_if_present()
    op.create_check_constraint(
        "ck_editor_system_permission_name",
        "cnr_editor_system_permission",
        "permission_name IN ('activate_cd_keys')",
    )
