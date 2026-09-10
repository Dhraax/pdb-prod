"""Add collaborator role and per-profession edit permissions."""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import mysql

revision: str = "0004_collaborator_permissions"
down_revision: str | None = "0003_technical_role"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def _drop_role_check_if_present() -> None:
    checks = {
        check["name"]
        for check in sa.inspect(op.get_bind()).get_check_constraints("cnr_editor_user")
    }
    if "ck_editor_user_role" in checks:
        op.drop_constraint("ck_editor_user_role", "cnr_editor_user", type_="check")


def upgrade() -> None:
    _drop_role_check_if_present()
    op.create_check_constraint(
        "ck_editor_user_role",
        "cnr_editor_user",
        "role IN ('admin','technical','editor','collaborator')",
    )

    if not sa.inspect(op.get_bind()).has_table("cnr_editor_profession_permission"):
        op.create_table(
            "cnr_editor_profession_permission",
            sa.Column("user_id", sa.Integer(), nullable=False),
            sa.Column("profession_id", mysql.SMALLINT(unsigned=True), nullable=False),
            sa.CheckConstraint(
                "profession_id > 0",
                name="ck_editor_permission_profession",
            ),
            sa.ForeignKeyConstraint(
                ["user_id"],
                ["cnr_editor_user.user_id"],
                ondelete="CASCADE",
            ),
            sa.PrimaryKeyConstraint("user_id", "profession_id"),
        )


def downgrade() -> None:
    op.execute("UPDATE cnr_editor_user SET role = 'editor' WHERE role = 'collaborator'")
    if sa.inspect(op.get_bind()).has_table("cnr_editor_profession_permission"):
        op.drop_table("cnr_editor_profession_permission")
    _drop_role_check_if_present()
    op.create_check_constraint(
        "ck_editor_user_role",
        "cnr_editor_user",
        "role IN ('admin','technical','editor')",
    )
