"""Preserve revision history when a control-panel user is deleted."""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0016_nullable_revision_actors"
down_revision: str | None = "0015_character_rebuild_counters"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None

REVISION_TABLES = (
    "cnr_catalogue_revision",
    "pwdb_identity_revision",
)


def _actor_foreign_key(table_name: str) -> dict | None:
    """Return the actor foreign key currently committed for a revision table."""
    for foreign_key in sa.inspect(op.get_bind()).get_foreign_keys(table_name):
        if foreign_key["constrained_columns"] == ["actor_user_id"]:
            return foreign_key
    return None


def _replace_actor_foreign_key(table_name: str, ondelete: str | None) -> None:
    """Replace the actor foreign key with the requested deletion policy."""
    foreign_key = _actor_foreign_key(table_name)
    if foreign_key is not None:
        op.drop_constraint(foreign_key["name"], table_name, type_="foreignkey")
    op.create_foreign_key(
        f"fk_{table_name}_actor_user",
        table_name,
        "cnr_editor_user",
        ["actor_user_id"],
        ["user_id"],
        ondelete=ondelete,
    )


def upgrade() -> None:
    for table_name in REVISION_TABLES:
        op.alter_column(
            table_name,
            "actor_user_id",
            existing_type=sa.Integer(),
            nullable=True,
        )
        _replace_actor_foreign_key(table_name, "SET NULL")


def downgrade() -> None:
    for table_name in REVISION_TABLES:
        op.execute(sa.text(f"DELETE FROM {table_name} WHERE actor_user_id IS NULL"))
        _replace_actor_foreign_key(table_name, None)
        op.alter_column(
            table_name,
            "actor_user_id",
            existing_type=sa.Integer(),
            nullable=False,
        )
