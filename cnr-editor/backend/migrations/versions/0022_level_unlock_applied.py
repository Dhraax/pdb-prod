"""Track when a level unlock reaches the character campaign store.

The identifier stays under 32 characters: that is the width of Alembic's
default alembic_version.version_num column, and a longer one is written
only after the DDL has already been committed, which leaves the database
with the column added and the revision unrecorded.
"""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0022_level_unlock_applied"
down_revision: str | None = "0021_character_tombstones"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def _has_column(table_name: str, column_name: str) -> bool:
    """Return whether a column already exists after a partial migration."""
    columns = sa.inspect(op.get_bind()).get_columns(table_name)
    return any(column["name"] == column_name for column in columns)


def upgrade() -> None:
    if not _has_column("pwdb_character_level_unlock", "applied_at"):
        op.add_column(
            "pwdb_character_level_unlock",
            sa.Column("applied_at", sa.DateTime(), nullable=True),
        )


def downgrade() -> None:
    if _has_column("pwdb_character_level_unlock", "applied_at"):
        op.drop_column("pwdb_character_level_unlock", "applied_at")
