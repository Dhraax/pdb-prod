"""Add optional email addresses to control-panel users."""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0006_control_panel_user_profiles"
down_revision: str | None = "0005_character_snapshot_marker"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def _has_email_column() -> bool:
    columns = sa.inspect(op.get_bind()).get_columns("cnr_editor_user")
    return any(column["name"] == "email" for column in columns)


def _email_unique_constraint_name() -> str | None:
    constraints = sa.inspect(op.get_bind()).get_unique_constraints("cnr_editor_user")
    for constraint in constraints:
        if constraint.get("column_names") == ["email"]:
            return constraint["name"]
    return None


def upgrade() -> None:
    if not _has_email_column():
        op.add_column(
            "cnr_editor_user",
            sa.Column("email", sa.String(length=254), nullable=True),
        )
    if _email_unique_constraint_name() is None:
        op.create_unique_constraint(
            "uq_editor_user_email",
            "cnr_editor_user",
            ["email"],
        )


def downgrade() -> None:
    constraint_name = _email_unique_constraint_name()
    if constraint_name is not None:
        op.drop_constraint(constraint_name, "cnr_editor_user", type_="unique")
    if _has_email_column():
        op.drop_column("cnr_editor_user", "email")
