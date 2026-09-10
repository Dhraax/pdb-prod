"""Persist administrator-assigned control-panel permissions."""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0013_system_user_permissions"
down_revision: str | None = "0012_dungeon_master_role"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    if not sa.inspect(op.get_bind()).has_table("cnr_editor_system_permission"):
        op.create_table(
            "cnr_editor_system_permission",
            sa.Column("user_id", sa.Integer(), nullable=False),
            sa.Column("permission_name", sa.String(length=32), nullable=False),
            sa.CheckConstraint(
                "permission_name IN ('activate_cd_keys')",
                name="ck_editor_system_permission_name",
            ),
            sa.ForeignKeyConstraint(
                ["user_id"],
                ["cnr_editor_user.user_id"],
                ondelete="CASCADE",
            ),
            sa.PrimaryKeyConstraint("user_id", "permission_name"),
        )

    op.execute(
        "INSERT IGNORE INTO cnr_editor_system_permission (user_id, permission_name) "
        "SELECT user_id, 'activate_cd_keys' FROM cnr_editor_user "
        "WHERE role IN ('technical', 'dungeon_master')"
    )


def downgrade() -> None:
    if sa.inspect(op.get_bind()).has_table("cnr_editor_system_permission"):
        op.drop_table("cnr_editor_system_permission")
