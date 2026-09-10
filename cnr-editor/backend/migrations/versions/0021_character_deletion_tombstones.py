"""Preserve deleted characters as tombstones and control same-name reuse."""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0021_character_tombstones"
down_revision: str | None = "0020_dm_cd_key_whitelist"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None

TABLE = "pwdb_character_profile"
ACTOR_INDEX = "ix_character_profile_name_reuse_unlocked_by"
ACTOR_FK = "fk_character_profile_name_reuse_unlocked_by"


def _columns() -> set[str]:
    return {item["name"] for item in sa.inspect(op.get_bind()).get_columns(TABLE)}


def upgrade() -> None:
    columns = _columns()
    if "deleted_at" not in columns:
        op.add_column(TABLE, sa.Column("deleted_at", sa.DateTime(), nullable=True))
    if "name_reuse_unlocked_at" not in columns:
        op.add_column(
            TABLE,
            sa.Column("name_reuse_unlocked_at", sa.DateTime(), nullable=True),
        )
    if "name_reuse_unlocked_by" not in columns:
        op.add_column(
            TABLE,
            sa.Column("name_reuse_unlocked_by", sa.Integer(), nullable=True),
        )

    inspector = sa.inspect(op.get_bind())
    foreign_keys = {item.get("name") for item in inspector.get_foreign_keys(TABLE)}
    if ACTOR_FK not in foreign_keys:
        op.create_foreign_key(
            ACTOR_FK,
            TABLE,
            "cnr_editor_user",
            ["name_reuse_unlocked_by"],
            ["user_id"],
            ondelete="SET NULL",
        )

    indexes = {item["name"] for item in sa.inspect(op.get_bind()).get_indexes(TABLE)}
    if ACTOR_INDEX not in indexes:
        op.create_index(ACTOR_INDEX, TABLE, ["name_reuse_unlocked_by"])

    op.execute(
        "UPDATE pwdb_character_profile "
        "SET deleted_at = COALESCE(deleted_at, updated_at, CURRENT_TIMESTAMP) "
        "WHERE status = 'deleted' AND deleted_at IS NULL"
    )


def downgrade() -> None:
    inspector = sa.inspect(op.get_bind())
    indexes = {item["name"] for item in inspector.get_indexes(TABLE)}
    if ACTOR_INDEX in indexes:
        op.drop_index(ACTOR_INDEX, table_name=TABLE)

    foreign_keys = {item.get("name") for item in sa.inspect(op.get_bind()).get_foreign_keys(TABLE)}
    if ACTOR_FK in foreign_keys:
        op.drop_constraint(ACTOR_FK, TABLE, type_="foreignkey")

    columns = _columns()
    for column_name in (
        "name_reuse_unlocked_by",
        "name_reuse_unlocked_at",
        "deleted_at",
    ):
        if column_name in columns:
            op.drop_column(TABLE, column_name)
