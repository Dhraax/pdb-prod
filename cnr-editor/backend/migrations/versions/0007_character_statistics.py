"""Store the base ability scores captured from the game engine."""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import mysql

revision: str = "0007_character_statistics"
down_revision: str | None = "0006_control_panel_user_profiles"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None

ABILITY_COLUMNS = (
    "strength_score",
    "dexterity_score",
    "constitution_score",
    "intelligence_score",
    "wisdom_score",
    "charisma_score",
)

ABILITY_CONSTRAINTS = {
    f"ck_character_profile_{column_name.removesuffix('_score')}": (
        f"{column_name} BETWEEN 0 AND 255"
    )
    for column_name in ABILITY_COLUMNS
}


def _column_names() -> set[str]:
    columns = sa.inspect(op.get_bind()).get_columns("pwdb_character_profile")
    return {column["name"] for column in columns}


def _constraint_names() -> set[str]:
    constraints = sa.inspect(op.get_bind()).get_check_constraints("pwdb_character_profile")
    return {constraint["name"] for constraint in constraints if constraint.get("name")}


def upgrade() -> None:
    existing = _column_names()
    for column_name in ABILITY_COLUMNS:
        if column_name not in existing:
            op.add_column(
                "pwdb_character_profile",
                sa.Column(column_name, mysql.TINYINT(unsigned=True), nullable=True),
            )
    existing_constraints = _constraint_names()
    for constraint_name, condition in ABILITY_CONSTRAINTS.items():
        if constraint_name not in existing_constraints:
            op.create_check_constraint(
                constraint_name,
                "pwdb_character_profile",
                condition,
            )


def downgrade() -> None:
    existing_constraints = _constraint_names()
    for constraint_name in reversed(ABILITY_CONSTRAINTS):
        if constraint_name in existing_constraints:
            op.drop_constraint(
                constraint_name,
                "pwdb_character_profile",
                type_="check",
            )
    existing = _column_names()
    for column_name in reversed(ABILITY_COLUMNS):
        if column_name in existing:
            op.drop_column("pwdb_character_profile", column_name)
