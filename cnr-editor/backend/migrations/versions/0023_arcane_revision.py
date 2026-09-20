"""Give arcane edits their own audit trail.

cnr_catalogue_revision cannot hold them: its foreign key is to cnr_recipe and
an arcane property is not a recipe. This table is owned by the control panel,
so it survives the catalogue rebuild that drops and recreates cnr_arcane_*.

The identifier stays under 32 characters: that is the width of Alembic's
default alembic_version.version_num column, and a longer one is written only
after the DDL has already been committed, which leaves the database with the
table created and the revision unrecorded.
"""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0023_arcane_revision"
down_revision: str | None = "0022_level_unlock_applied"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def _has_table(table_name: str) -> bool:
    """Return whether the table already exists after a partial migration."""
    return sa.inspect(op.get_bind()).has_table(table_name)


def upgrade() -> None:
    if _has_table("cnr_arcane_revision"):
        return
    op.create_table(
        "cnr_arcane_revision",
        sa.Column("revision_id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("arcane_id", sa.SmallInteger(), nullable=False),
        sa.Column("actor_user_id", sa.Integer(), nullable=True),
        sa.Column("action", sa.String(length=16), nullable=False),
        sa.Column(
            "changed_at",
            sa.DateTime(),
            server_default=sa.func.current_timestamp(),
            nullable=False,
        ),
        sa.Column("before_json", sa.JSON(), nullable=False),
        sa.Column("after_json", sa.JSON(), nullable=False),
        sa.Column("note", sa.Text(), nullable=True),
        sa.ForeignKeyConstraint(
            ["actor_user_id"], ["cnr_editor_user.user_id"], ondelete="SET NULL"
        ),
        sa.PrimaryKeyConstraint("revision_id"),
    )
    op.create_index("ix_cnr_arcane_revision_arcane_id", "cnr_arcane_revision", ["arcane_id"])


def downgrade() -> None:
    if not _has_table("cnr_arcane_revision"):
        return
    op.drop_index("ix_cnr_arcane_revision_arcane_id", table_name="cnr_arcane_revision")
    op.drop_table("cnr_arcane_revision")
