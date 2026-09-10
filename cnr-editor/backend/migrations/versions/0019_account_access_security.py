"""Add account access history and persistent public CD-key bans."""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0019_account_access_security"
down_revision: str | None = "0018_mfa_and_login_throttle"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    inspector = sa.inspect(op.get_bind())
    tables = set(inspector.get_table_names())

    if "pwdb_account_name_history" not in tables:
        op.create_table(
            "pwdb_account_name_history",
            sa.Column("account_id", sa.Integer(), nullable=False),
            sa.Column("player_name", sa.String(length=64), nullable=False),
            sa.Column(
                "first_seen_at",
                sa.DateTime(),
                server_default=sa.func.current_timestamp(),
                nullable=False,
            ),
            sa.Column(
                "last_seen_at",
                sa.DateTime(),
                server_default=sa.func.current_timestamp(),
                nullable=False,
            ),
            sa.Column("verified_count", sa.BigInteger(), server_default="0", nullable=False),
            sa.ForeignKeyConstraint(
                ["account_id"], ["pwdb_account.account_id"], ondelete="CASCADE"
            ),
            sa.PrimaryKeyConstraint("account_id", "player_name"),
        )
        op.create_index(
            "ix_account_name_history_name",
            "pwdb_account_name_history",
            ["player_name"],
        )

    if "pwdb_account_cd_key_history" not in tables:
        op.create_table(
            "pwdb_account_cd_key_history",
            sa.Column("account_id", sa.Integer(), nullable=False),
            sa.Column("cd_key", sa.String(length=16), nullable=False),
            sa.Column(
                "first_seen_at",
                sa.DateTime(),
                server_default=sa.func.current_timestamp(),
                nullable=False,
            ),
            sa.Column(
                "last_seen_at",
                sa.DateTime(),
                server_default=sa.func.current_timestamp(),
                nullable=False,
            ),
            sa.Column("attempt_count", sa.BigInteger(), server_default="0", nullable=False),
            sa.Column("verified_count", sa.BigInteger(), server_default="0", nullable=False),
            sa.Column("last_player_name", sa.String(length=64), nullable=True),
            sa.ForeignKeyConstraint(
                ["account_id"], ["pwdb_account.account_id"], ondelete="CASCADE"
            ),
            sa.PrimaryKeyConstraint("account_id", "cd_key"),
        )
        op.create_index(
            "ix_account_cd_key_history_key",
            "pwdb_account_cd_key_history",
            ["cd_key"],
        )

    if "pwdb_account_ip_history" not in tables:
        op.create_table(
            "pwdb_account_ip_history",
            sa.Column("account_id", sa.Integer(), nullable=False),
            sa.Column("ip_address", sa.String(length=45), nullable=False),
            sa.Column(
                "first_seen_at",
                sa.DateTime(),
                server_default=sa.func.current_timestamp(),
                nullable=False,
            ),
            sa.Column(
                "last_seen_at",
                sa.DateTime(),
                server_default=sa.func.current_timestamp(),
                nullable=False,
            ),
            sa.Column("attempt_count", sa.BigInteger(), server_default="0", nullable=False),
            sa.Column("verified_count", sa.BigInteger(), server_default="0", nullable=False),
            sa.ForeignKeyConstraint(
                ["account_id"], ["pwdb_account.account_id"], ondelete="CASCADE"
            ),
            sa.PrimaryKeyConstraint("account_id", "ip_address"),
        )
        op.create_index(
            "ix_account_ip_history_address",
            "pwdb_account_ip_history",
            ["ip_address"],
        )

    if "pwdb_cd_key_ban" not in tables:
        op.create_table(
            "pwdb_cd_key_ban",
            sa.Column("cd_key", sa.String(length=16), nullable=False),
            sa.Column("active", sa.Boolean(), server_default=sa.true(), nullable=False),
            sa.Column("reason", sa.String(length=500), nullable=True),
            sa.Column("banned_at", sa.DateTime(), nullable=False),
            sa.Column("unbanned_at", sa.DateTime(), nullable=True),
            sa.Column("updated_at", sa.DateTime(), nullable=False),
            sa.PrimaryKeyConstraint("cd_key"),
        )
        op.create_index("ix_cd_key_ban_active", "pwdb_cd_key_ban", ["active"])

    op.execute(
        "INSERT IGNORE INTO pwdb_account_name_history "
        "(account_id, player_name, first_seen_at, last_seen_at, verified_count) "
        "SELECT account_id, player_name, first_seen, last_seen, 1 "
        "FROM pwdb_account WHERE player_name IS NOT NULL AND player_name <> ''"
    )
    op.execute(
        "INSERT IGNORE INTO pwdb_account_cd_key_history "
        "(account_id, cd_key, first_seen_at, last_seen_at, attempt_count, "
        "verified_count, last_player_name) "
        "SELECT account_id, cd_key, first_seen, last_seen, 1, 1, player_name "
        "FROM pwdb_account"
    )


def downgrade() -> None:
    op.drop_index("ix_cd_key_ban_active", table_name="pwdb_cd_key_ban")
    op.drop_table("pwdb_cd_key_ban")
    op.drop_index("ix_account_ip_history_address", table_name="pwdb_account_ip_history")
    op.drop_table("pwdb_account_ip_history")
    op.drop_index("ix_account_cd_key_history_key", table_name="pwdb_account_cd_key_history")
    op.drop_table("pwdb_account_cd_key_history")
    op.drop_index("ix_account_name_history_name", table_name="pwdb_account_name_history")
    op.drop_table("pwdb_account_name_history")
