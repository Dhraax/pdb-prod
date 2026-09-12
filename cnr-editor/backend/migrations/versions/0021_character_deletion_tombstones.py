"""Preserve deleted characters as immutable historical tombstones."""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0021_character_tombstones"
down_revision: str | None = "0020_dm_cd_key_whitelist"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None

TABLE = "pwdb_character_profile"


def _columns() -> set[str]:
    return {item["name"] for item in sa.inspect(op.get_bind()).get_columns(TABLE)}


def upgrade() -> None:
    columns = _columns()
    if "deleted_at" not in columns:
        op.add_column(TABLE, sa.Column("deleted_at", sa.DateTime(), nullable=True))

    op.execute(
        "UPDATE pwdb_character_profile "
        "SET deleted_at = COALESCE(deleted_at, updated_at, CURRENT_TIMESTAMP) "
        "WHERE status = 'deleted' AND deleted_at IS NULL"
    )


def downgrade() -> None:
    if "deleted_at" in _columns():
        op.drop_column(TABLE, "deleted_at")
