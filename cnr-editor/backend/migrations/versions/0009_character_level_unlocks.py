"""Store irreversible character level-unlock grants."""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import mysql

revision: str = "0009_character_level_unlocks"
down_revision: str | None = "0008_access_status_policy"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None

UNLOCK_LEVELS = (9, 13, 17, 21, 22, 24, 26, 30, 35)


def _has_table(table_name: str) -> bool:
    """Return whether MySQL already committed the table during a partial run."""
    return sa.inspect(op.get_bind()).has_table(table_name)


def upgrade() -> None:
    if _has_table("pwdb_character_level_unlock"):
        return
    op.create_table(
        "pwdb_character_level_unlock",
        sa.Column("character_id", sa.Integer(), nullable=False),
        sa.Column("unlock_level", mysql.TINYINT(unsigned=True), nullable=False),
        sa.Column("granted_by", sa.Integer(), nullable=True),
        sa.Column(
            "granted_at",
            sa.DateTime(),
            server_default=sa.func.current_timestamp(),
            nullable=False,
        ),
        sa.CheckConstraint(
            f"unlock_level IN ({','.join(map(str, UNLOCK_LEVELS))})",
            name="ck_character_level_unlock_level",
        ),
        sa.ForeignKeyConstraint(
            ["character_id"],
            ["pwdb_character.character_id"],
            ondelete="CASCADE",
        ),
        sa.ForeignKeyConstraint(
            ["granted_by"],
            ["cnr_editor_user.user_id"],
            ondelete="SET NULL",
        ),
        sa.PrimaryKeyConstraint("character_id", "unlock_level"),
    )


def downgrade() -> None:
    if _has_table("pwdb_character_level_unlock"):
        op.drop_table("pwdb_character_level_unlock")
