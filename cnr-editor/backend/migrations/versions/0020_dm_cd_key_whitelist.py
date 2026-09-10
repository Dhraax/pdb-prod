"""Add the pre-vault DM public CD-key whitelist and its audit history."""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0020_dm_cd_key_whitelist"
down_revision: str | None = "0019_account_access_security"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    inspector = sa.inspect(op.get_bind())
    tables = set(inspector.get_table_names())

    if "pwdb_dm_cd_key_whitelist" not in tables:
        op.create_table(
            "pwdb_dm_cd_key_whitelist",
            sa.Column("cd_key", sa.String(length=16), nullable=False),
            sa.Column("display_name", sa.String(length=64), nullable=True),
            sa.Column(
                "added_at",
                sa.DateTime(),
                server_default=sa.func.current_timestamp(),
                nullable=False,
            ),
            sa.PrimaryKeyConstraint("cd_key"),
        )

    if "pwdb_dm_cd_key_whitelist_revision" not in tables:
        op.create_table(
            "pwdb_dm_cd_key_whitelist_revision",
            sa.Column("revision_id", sa.BigInteger(), autoincrement=True, nullable=False),
            sa.Column("cd_key", sa.String(length=16), nullable=False),
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
            sa.ForeignKeyConstraint(
                ["actor_user_id"], ["cnr_editor_user.user_id"], ondelete="SET NULL"
            ),
            sa.PrimaryKeyConstraint("revision_id"),
        )
        op.create_index(
            "ix_dm_cd_key_whitelist_revision_key",
            "pwdb_dm_cd_key_whitelist_revision",
            ["cd_key"],
        )
        op.create_index(
            "ix_dm_cd_key_whitelist_revision_actor",
            "pwdb_dm_cd_key_whitelist_revision",
            ["actor_user_id"],
        )


def downgrade() -> None:
    op.drop_index(
        "ix_dm_cd_key_whitelist_revision_actor",
        table_name="pwdb_dm_cd_key_whitelist_revision",
    )
    op.drop_index(
        "ix_dm_cd_key_whitelist_revision_key",
        table_name="pwdb_dm_cd_key_whitelist_revision",
    )
    op.drop_table("pwdb_dm_cd_key_whitelist_revision")
    op.drop_table("pwdb_dm_cd_key_whitelist")
