"""Authorization and persistence tests for the DM CD-key whitelist."""

from datetime import UTC, datetime, timedelta

import pytest
from fastapi import HTTPException
from pydantic import ValidationError
from sqlalchemy import create_engine, select
from sqlalchemy.orm import Session as DatabaseSession

from app.dependencies import SessionContext, require_dm_access_manager
from app.models import (
    CdKeyBan,
    DmCdKeyWhitelist,
    DmCdKeyWhitelistRevision,
    EditorSession,
    EditorUser,
)
from app.routers.dm_access import add_dm_cd_key, list_dm_cd_keys, remove_dm_cd_key
from app.schemas import DmCdKeyWhitelistCreate


def _context(user: EditorUser) -> SessionContext:
    now = datetime.now(UTC).replace(tzinfo=None)
    return SessionContext(
        user=user,
        session=EditorSession(
            token_hash="test-token",
            csrf_token_hash="test-csrf",
            user_id=user.user_id,
            created_at=now,
            expires_at=now + timedelta(hours=1),
        ),
    )


def _engine():
    engine = create_engine("sqlite+pysqlite:///:memory:")
    for table in (
        EditorUser.__table__,
        CdKeyBan.__table__,
        DmCdKeyWhitelist.__table__,
        DmCdKeyWhitelistRevision.__table__,
    ):
        table.create(engine)
    return engine


@pytest.mark.parametrize("role", ["admin", "technical"])
def test_dm_access_manager_accepts_only_privileged_roles(role: str) -> None:
    user = EditorUser(username=f"dm-access-{role}", password_hash="unused", role=role)

    assert require_dm_access_manager(user) is user


@pytest.mark.parametrize("role", ["dungeon_master", "editor", "collaborator"])
def test_dm_access_manager_rejects_other_roles(role: str) -> None:
    user = EditorUser(username=f"dm-access-{role}", password_hash="unused", role=role)

    with pytest.raises(HTTPException) as raised:
        require_dm_access_manager(user)

    assert raised.value.status_code == 403


def test_dm_cd_key_payload_normalizes_key_and_optional_name() -> None:
    payload = DmCdKeyWhitelistCreate(cd_key="  uxFmcrdy  ", display_name="  Amber  ")

    assert payload.cd_key == "UXFMCRDY"
    assert payload.display_name == "Amber"


@pytest.mark.parametrize("cd_key", ["", "key-with-dash", "key with space", "A" * 17])
def test_dm_cd_key_payload_rejects_invalid_keys(cd_key: str) -> None:
    with pytest.raises(ValidationError):
        DmCdKeyWhitelistCreate(cd_key=cd_key)


def test_admin_can_add_list_and_remove_dm_cd_key_with_audit() -> None:
    engine = _engine()
    with DatabaseSession(engine) as db:
        user = EditorUser(
            user_id=1,
            username="dm-access-admin",
            password_hash="unused",
            role="admin",
        )
        db.add(user)
        db.commit()
        context = _context(user)

        created = add_dm_cd_key(
            DmCdKeyWhitelistCreate(cd_key="uxfmcrdy", display_name="Amber"),
            context,
            db,
        )
        listed = list_dm_cd_keys(user, db)

        assert created.cd_key == "UXFMCRDY"
        assert created.globally_banned is False
        assert [entry.cd_key for entry in listed] == ["UXFMCRDY"]
        assert db.scalars(select(DmCdKeyWhitelistRevision.action)).all() == [
            "whitelist_add"
        ]

        response = remove_dm_cd_key("uxfmcrdy", context, db)

        assert response.status_code == 204
        assert db.get(DmCdKeyWhitelist, "UXFMCRDY") is None
        assert db.scalars(
            select(DmCdKeyWhitelistRevision.action).order_by(
                DmCdKeyWhitelistRevision.revision_id
            )
        ).all() == ["whitelist_add", "whitelist_remove"]


def test_globally_banned_key_cannot_be_added_to_dm_whitelist() -> None:
    engine = _engine()
    now = datetime.now(UTC).replace(tzinfo=None)
    with DatabaseSession(engine) as db:
        user = EditorUser(
            user_id=1,
            username="dm-access-technical",
            password_hash="unused",
            role="technical",
        )
        db.add(user)
        db.add(
            CdKeyBan(
                cd_key="BANNEDKEY",
                active=True,
                banned_at=now,
                updated_at=now,
            )
        )
        db.commit()

        with pytest.raises(HTTPException) as raised:
            add_dm_cd_key(
                DmCdKeyWhitelistCreate(cd_key="BANNEDKEY"),
                _context(user),
                db,
            )

        assert raised.value.status_code == 409
        assert db.get(DmCdKeyWhitelist, "BANNEDKEY") is None
