"""Add persistent per-character rebuild counters."""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import mysql

revision: str = "0015_character_rebuild_counters"
down_revision: str | None = "0014_integral_permissions"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def _column_names() -> set[str]:
    """Return the committed character columns during a partial MySQL run."""
    return {
        column["name"]
        for column in sa.inspect(op.get_bind()).get_columns("pwdb_character")
    }


def _check_names() -> set[str]:
    """Return the committed character checks during a partial MySQL run."""
    return {
        check["name"]
        for check in sa.inspect(op.get_bind()).get_check_constraints("pwdb_character")
    }


def upgrade() -> None:
    columns = _column_names()
    if "rebuilds_available" not in columns:
        op.add_column(
            "pwdb_character",
            sa.Column(
                "rebuilds_available",
                mysql.SMALLINT(unsigned=True),
                server_default=sa.text("2"),
                nullable=False,
            ),
        )
    if "rebuilds_completed" not in columns:
        op.add_column(
            "pwdb_character",
            sa.Column(
                "rebuilds_completed",
                mysql.INTEGER(unsigned=True),
                server_default=sa.text("0"),
                nullable=False,
            ),
        )

    checks = _check_names()
    if "ck_character_rebuilds_available" not in checks:
        op.create_check_constraint(
            "ck_character_rebuilds_available",
            "pwdb_character",
            "rebuilds_available >= 0",
        )
    if "ck_character_rebuilds_completed" not in checks:
        op.create_check_constraint(
            "ck_character_rebuilds_completed",
            "pwdb_character",
            "rebuilds_completed >= 0",
        )


def downgrade() -> None:
    checks = _check_names()
    if "ck_character_rebuilds_completed" in checks:
        op.drop_constraint(
            "ck_character_rebuilds_completed",
            "pwdb_character",
            type_="check",
        )
    if "ck_character_rebuilds_available" in checks:
        op.drop_constraint(
            "ck_character_rebuilds_available",
            "pwdb_character",
            type_="check",
        )

    columns = _column_names()
    if "rebuilds_completed" in columns:
        op.drop_column("pwdb_character", "rebuilds_completed")
    if "rebuilds_available" in columns:
        op.drop_column("pwdb_character", "rebuilds_available")
