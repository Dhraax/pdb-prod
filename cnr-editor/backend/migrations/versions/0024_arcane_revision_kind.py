"""Let the arcane audit trail record a group edit as well as a property one.

cnr_arcane_revision was written for cnr_arcane_property. Groups are now
editable from the panel too, and a group id and a property id are separate
number spaces, so the row has to say which one it is talking about.

Existing rows are property edits: that is all the table could hold until now,
which is why the default backfills them correctly.

The identifier stays under 32 characters: that is the width of Alembic's
default alembic_version.version_num column, and a longer one is written only
after the DDL has already been committed, which leaves the database with the
column added and the revision unrecorded.
"""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0024_arcane_revision_kind"
down_revision: str | None = "0023_arcane_revision"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def _has_column(table_name: str, column_name: str) -> bool:
    """Return whether a column already exists after a partial migration."""
    columns = sa.inspect(op.get_bind()).get_columns(table_name)
    return any(column["name"] == column_name for column in columns)


def upgrade() -> None:
    if not _has_column("cnr_arcane_revision", "target_kind"):
        op.add_column(
            "cnr_arcane_revision",
            sa.Column(
                "target_kind",
                sa.String(length=16),
                nullable=False,
                server_default="property",
            ),
        )


def downgrade() -> None:
    if _has_column("cnr_arcane_revision", "target_kind"):
        op.drop_column("cnr_arcane_revision", "target_kind")
