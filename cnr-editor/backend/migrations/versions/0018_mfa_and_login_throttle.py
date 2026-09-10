"""Add TOTP MFA, recovery codes, login challenges and account throttling."""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0018_mfa_and_login_throttle"
down_revision: str | None = "0017_system_user_audit"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    inspector = sa.inspect(op.get_bind())
    tables = set(inspector.get_table_names())

    if "cnr_editor_totp_credential" not in tables:
        op.create_table(
            "cnr_editor_totp_credential",
            sa.Column("user_id", sa.Integer(), nullable=False),
            sa.Column("secret_ciphertext", sa.String(length=512), nullable=False),
            sa.Column(
                "created_at",
                sa.DateTime(),
                server_default=sa.func.current_timestamp(),
                nullable=False,
            ),
            sa.Column("confirmed_at", sa.DateTime(), nullable=True),
            sa.Column("last_used_step", sa.BigInteger(), nullable=True),
            sa.ForeignKeyConstraint(
                ["user_id"], ["cnr_editor_user.user_id"], ondelete="CASCADE"
            ),
            sa.PrimaryKeyConstraint("user_id"),
        )

    if "cnr_editor_mfa_recovery_code" not in tables:
        op.create_table(
            "cnr_editor_mfa_recovery_code",
            sa.Column("user_id", sa.Integer(), nullable=False),
            sa.Column("code_hash", sa.String(length=64), nullable=False),
            sa.Column(
                "created_at",
                sa.DateTime(),
                server_default=sa.func.current_timestamp(),
                nullable=False,
            ),
            sa.Column("used_at", sa.DateTime(), nullable=True),
            sa.ForeignKeyConstraint(
                ["user_id"],
                ["cnr_editor_totp_credential.user_id"],
                ondelete="CASCADE",
            ),
            sa.PrimaryKeyConstraint("user_id", "code_hash"),
        )

    if "cnr_editor_mfa_challenge" not in tables:
        op.create_table(
            "cnr_editor_mfa_challenge",
            sa.Column("token_hash", sa.String(length=64), nullable=False),
            sa.Column("user_id", sa.Integer(), nullable=False),
            sa.Column(
                "created_at",
                sa.DateTime(),
                server_default=sa.func.current_timestamp(),
                nullable=False,
            ),
            sa.Column("expires_at", sa.DateTime(), nullable=False),
            sa.Column("failed_attempts", sa.SmallInteger(), server_default="0", nullable=False),
            sa.ForeignKeyConstraint(
                ["user_id"], ["cnr_editor_user.user_id"], ondelete="CASCADE"
            ),
            sa.PrimaryKeyConstraint("token_hash"),
        )
        op.create_index(
            "ix_editor_mfa_challenge_user",
            "cnr_editor_mfa_challenge",
            ["user_id"],
        )
        op.create_index(
            "ix_editor_mfa_challenge_expiry",
            "cnr_editor_mfa_challenge",
            ["expires_at"],
        )

    if "cnr_editor_login_throttle" not in tables:
        op.create_table(
            "cnr_editor_login_throttle",
            sa.Column("subject_hash", sa.String(length=64), nullable=False),
            sa.Column("failed_attempts", sa.SmallInteger(), server_default="0", nullable=False),
            sa.Column("window_started_at", sa.DateTime(), nullable=False),
            sa.Column("blocked_until", sa.DateTime(), nullable=True),
            sa.Column(
                "updated_at",
                sa.DateTime(),
                server_default=sa.text("CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"),
                nullable=False,
            ),
            sa.PrimaryKeyConstraint("subject_hash"),
        )
        op.create_index(
            "ix_editor_login_throttle_blocked",
            "cnr_editor_login_throttle",
            ["blocked_until"],
        )


def downgrade() -> None:
    op.drop_index(
        "ix_editor_login_throttle_blocked", table_name="cnr_editor_login_throttle"
    )
    op.drop_table("cnr_editor_login_throttle")
    op.drop_index("ix_editor_mfa_challenge_expiry", table_name="cnr_editor_mfa_challenge")
    op.drop_index("ix_editor_mfa_challenge_user", table_name="cnr_editor_mfa_challenge")
    op.drop_table("cnr_editor_mfa_challenge")
    op.drop_table("cnr_editor_mfa_recovery_code")
    op.drop_table("cnr_editor_totp_credential")
