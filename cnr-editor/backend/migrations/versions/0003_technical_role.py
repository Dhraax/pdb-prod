"""Allow the technical-team editor role."""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0003_technical_role"
down_revision: str | None = "0002_identity_management"
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
        "role IN ('admin','technical','editor')",
    )


def downgrade() -> None:
    op.execute("UPDATE cnr_editor_user SET role = 'editor' WHERE role = 'technical'")
    _drop_role_check_if_present()
    op.create_check_constraint(
        "ck_editor_user_role",
        "cnr_editor_user",
        "role IN ('admin','editor')",
    )
