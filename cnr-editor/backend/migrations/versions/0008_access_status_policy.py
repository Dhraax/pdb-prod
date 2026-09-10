"""Simplify account and character access statuses."""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0008_access_status_policy"
down_revision: str | None = "0007_character_statistics"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def _constraint_names(table_name: str) -> set[str]:
    constraints = sa.inspect(op.get_bind()).get_check_constraints(table_name)
    return {constraint["name"] for constraint in constraints if constraint.get("name")}


def _drop_check_if_present(table_name: str, constraint_name: str) -> None:
    if constraint_name in _constraint_names(table_name):
        op.drop_constraint(constraint_name, table_name, type_="check")


def _create_check_if_missing(
    table_name: str,
    constraint_name: str,
    condition: str,
) -> None:
    if constraint_name not in _constraint_names(table_name):
        op.create_check_constraint(constraint_name, table_name, condition)


def upgrade() -> None:
    _drop_check_if_present("pwdb_account_management", "ck_account_management_status")
    _drop_check_if_present("pwdb_character_profile", "ck_character_profile_status")

    op.execute(
        "UPDATE pwdb_account_management SET status = 'blocked' "
        "WHERE status IN ('suspended', 'banned', 'archived')"
    )
    op.execute(
        "UPDATE pwdb_character_profile SET status = 'blocked' WHERE status = 'retired'"
    )

    _create_check_if_missing(
        "pwdb_account_management",
        "ck_account_management_status",
        "status IN ('active','blocked')",
    )
    _create_check_if_missing(
        "pwdb_character_profile",
        "ck_character_profile_status",
        "status IN ('active','blocked','deleted')",
    )


def downgrade() -> None:
    _drop_check_if_present("pwdb_account_management", "ck_account_management_status")
    _drop_check_if_present("pwdb_character_profile", "ck_character_profile_status")

    op.execute("UPDATE pwdb_account_management SET status = 'suspended' WHERE status = 'blocked'")

    _create_check_if_missing(
        "pwdb_account_management",
        "ck_account_management_status",
        "status IN ('active','suspended','banned','archived')",
    )
    _create_check_if_missing(
        "pwdb_character_profile",
        "ck_character_profile_status",
        "status IN ('active','retired','blocked','deleted')",
    )
