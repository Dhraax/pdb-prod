"""Mark one-time engine character snapshot imports."""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import mysql

revision: str = "0005_character_snapshot_marker"
down_revision: str | None = "0004_collaborator_permissions"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def _has_snapshot_marker() -> bool:
    columns = sa.inspect(op.get_bind()).get_columns("pwdb_character_profile")
    return any(column["name"] == "snapshot_captured_at" for column in columns)


def upgrade() -> None:
    if not _has_snapshot_marker():
        op.add_column(
            "pwdb_character_profile",
            sa.Column("snapshot_captured_at", mysql.DATETIME(fsp=6), nullable=True),
        )


def downgrade() -> None:
    if _has_snapshot_marker():
        op.drop_column("pwdb_character_profile", "snapshot_captured_at")
