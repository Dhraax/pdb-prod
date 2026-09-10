"""Add controlled game-account CD-key recapture state."""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import mysql

revision: str = "0011_account_cdkey_reset"
down_revision: str | None = "0010_character_rebuild_cleanup"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def _has_table(table_name: str) -> bool:
    """Return whether MySQL already committed the table during a partial run."""
    return sa.inspect(op.get_bind()).has_table(table_name)


def upgrade() -> None:
    if _has_table("pwdb_account_cdkey_reset"):
        return
    op.create_table(
        "pwdb_account_cdkey_reset",
        sa.Column("account_id", sa.Integer(), nullable=False),
        sa.Column("candidate_cd_key", sa.String(length=16), nullable=True),
        sa.Column("requested_by", sa.Integer(), nullable=True),
        sa.Column(
            "requested_at",
            mysql.DATETIME(fsp=6),
            server_default=sa.text("CURRENT_TIMESTAMP(6)"),
            nullable=False,
        ),
        sa.Column("expires_at", mysql.DATETIME(fsp=6), nullable=False),
        sa.Column("candidate_captured_at", mysql.DATETIME(fsp=6), nullable=True),
        sa.Column("confirmed_by", sa.Integer(), nullable=True),
        sa.Column("confirmed_at", mysql.DATETIME(fsp=6), nullable=True),
        sa.ForeignKeyConstraint(
            ["account_id"], ["pwdb_account.account_id"], ondelete="CASCADE"
        ),
        sa.ForeignKeyConstraint(
            ["requested_by"], ["cnr_editor_user.user_id"], ondelete="SET NULL"
        ),
        sa.ForeignKeyConstraint(
            ["confirmed_by"], ["cnr_editor_user.user_id"], ondelete="SET NULL"
        ),
        sa.PrimaryKeyConstraint("account_id"),
        sa.UniqueConstraint("candidate_cd_key", name="uq_account_cdkey_reset_candidate"),
    )


def downgrade() -> None:
    if _has_table("pwdb_account_cdkey_reset"):
        op.drop_table("pwdb_account_cdkey_reset")
