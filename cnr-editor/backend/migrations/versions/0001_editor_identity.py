"""Create editor identity, sessions, history and precise recipe timestamps."""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import mysql

revision: str = "0001_editor_identity"
down_revision: str | None = None
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    inspector = sa.inspect(op.get_bind())
    tables = set(inspector.get_table_names())
    if "cnr_editor_user" not in tables:
        op.create_table(
            "cnr_editor_user",
            sa.Column("user_id", sa.Integer(), autoincrement=True, nullable=False),
            sa.Column("username", sa.String(length=64), nullable=False),
            sa.Column("password_hash", sa.String(length=255), nullable=False),
            sa.Column("role", sa.String(length=16), server_default="editor", nullable=False),
            sa.Column("active", sa.Boolean(), server_default=sa.true(), nullable=False),
            sa.Column(
                "created_at",
                sa.DateTime(),
                server_default=sa.func.current_timestamp(),
                nullable=False,
            ),
            sa.Column(
                "updated_at",
                sa.DateTime(),
                server_default=sa.text("CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"),
                nullable=False,
            ),
            sa.CheckConstraint("role IN ('admin','editor')", name="ck_editor_user_role"),
            sa.PrimaryKeyConstraint("user_id"),
            sa.UniqueConstraint("username", name="uq_editor_user_username"),
        )
    if "cnr_editor_session" not in tables:
        op.create_table(
            "cnr_editor_session",
            sa.Column("token_hash", sa.String(length=64), nullable=False),
            sa.Column("csrf_token_hash", sa.String(length=64), nullable=False),
            sa.Column("user_id", sa.Integer(), nullable=False),
            sa.Column(
                "created_at",
                sa.DateTime(),
                server_default=sa.func.current_timestamp(),
                nullable=False,
            ),
            sa.Column("expires_at", sa.DateTime(), nullable=False),
            sa.ForeignKeyConstraint(["user_id"], ["cnr_editor_user.user_id"], ondelete="CASCADE"),
            sa.PrimaryKeyConstraint("token_hash"),
        )
        op.create_index("ix_editor_session_user", "cnr_editor_session", ["user_id"])
        op.create_index("ix_editor_session_expiry", "cnr_editor_session", ["expires_at"])
    op.execute(
        "ALTER TABLE cnr_recipe MODIFY updated_at DATETIME(6) NOT NULL "
        "DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)"
    )
    if "cnr_catalogue_revision" not in tables:
        op.create_table(
            "cnr_catalogue_revision",
            sa.Column("revision_id", sa.Integer(), autoincrement=True, nullable=False),
            sa.Column("recipe_id", mysql.MEDIUMINT(unsigned=True), nullable=False),
            sa.Column("actor_user_id", sa.Integer(), nullable=False),
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
            sa.ForeignKeyConstraint(["actor_user_id"], ["cnr_editor_user.user_id"]),
            sa.ForeignKeyConstraint(["recipe_id"], ["cnr_recipe.recipe_id"]),
            sa.PrimaryKeyConstraint("revision_id"),
        )
        op.create_index("ix_catalogue_revision_recipe", "cnr_catalogue_revision", ["recipe_id"])


def downgrade() -> None:
    op.drop_index("ix_catalogue_revision_recipe", table_name="cnr_catalogue_revision")
    op.drop_table("cnr_catalogue_revision")
    op.execute(
        "ALTER TABLE cnr_recipe MODIFY updated_at DATETIME NOT NULL "
        "DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"
    )
    op.drop_index("ix_editor_session_expiry", table_name="cnr_editor_session")
    op.drop_index("ix_editor_session_user", table_name="cnr_editor_session")
    op.drop_table("cnr_editor_session")
    op.drop_table("cnr_editor_user")
