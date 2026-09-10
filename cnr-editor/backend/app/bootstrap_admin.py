"""Interactive bootstrap command for the first editor administrator."""

import getpass
import re

from sqlalchemy import func, select

from app.database import SessionLocal
from app.models import (
    EditorProfessionPermission,
    EditorSystemPermission,
    EditorUser,
    Profession,
)
from app.permissions import ROLE_PERMISSION_PRESETS
from app.security import hash_password


def main() -> None:
    with SessionLocal() as db:
        count = db.scalar(select(func.count()).select_from(EditorUser)) or 0
        if count:
            raise SystemExit("Bootstrap refused: an editor user already exists.")
        username = input("Initial admin username: ").strip()
        if not re.fullmatch(r"[A-Za-z0-9_.-]{3,64}", username):
            raise SystemExit(
                "Username must contain 3-64 letters, numbers, dots, hyphens or underscores."
            )
        password = getpass.getpass("Initial admin password (minimum 12 characters): ")
        confirmation = getpass.getpass("Confirm password: ")
        if len(password) < 12:
            raise SystemExit("Password must contain at least 12 characters.")
        if password != confirmation:
            raise SystemExit("Passwords do not match.")
        profession_ids = db.scalars(select(Profession.profession_id)).all()
        db.add(
            EditorUser(
                username=username,
                password_hash=hash_password(password),
                role="admin",
                profession_permissions=[
                    EditorProfessionPermission(profession_id=profession_id)
                    for profession_id in profession_ids
                ],
                system_permissions=[
                    EditorSystemPermission(permission_name=permission_name)
                    for permission_name in ROLE_PERMISSION_PRESETS["admin"]
                ],
            )
        )
        db.commit()
    print("Initial administrator created.")


if __name__ == "__main__":
    main()
