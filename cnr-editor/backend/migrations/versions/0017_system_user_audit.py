"""Audit control-panel user administration without storing password hashes."""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0017_system_user_audit"
down_revision: str | None = "0016_nullable_revision_actors"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    if "cnr_editor_user_revision" in sa.inspect(op.get_bind()).get_table_names():
        return
    op.create_table(
        "cnr_editor_user_revision",
        sa.Column("revision_id", sa.BigInteger(), autoincrement=True, nullable=False),
        sa.Column("target_user_id", sa.Integer(), nullable=False),
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
            ["actor_user_id"],
            ["cnr_editor_user.user_id"],
            name="fk_editor_user_revision_actor_user",
            ondelete="SET NULL",
        ),
        sa.PrimaryKeyConstraint("revision_id"),
    )
    op.create_index(
        "ix_editor_user_revision_target",
        "cnr_editor_user_revision",
        ["target_user_id"],
    )
    op.create_index(
        "ix_editor_user_revision_actor",
        "cnr_editor_user_revision",
        ["actor_user_id"],
    )
    op.create_index(
        "ix_editor_user_revision_changed",
        "cnr_editor_user_revision",
        ["changed_at"],
    )


def downgrade() -> None:
    if "cnr_editor_user_revision" in sa.inspect(op.get_bind()).get_table_names():
        op.drop_table("cnr_editor_user_revision")
