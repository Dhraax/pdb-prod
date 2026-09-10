"""Password, session-token, CSRF and MFA primitives."""

import base64
import hashlib
import io
import secrets
from datetime import UTC, datetime

import pyotp
import segno
from cryptography.fernet import Fernet, InvalidToken
from pwdlib import PasswordHash

password_hasher = PasswordHash.recommended()
dummy_password_hash = password_hasher.hash(secrets.token_urlsafe(32))


def hash_password(password: str) -> str:
    """Hash a password with the configured Argon2 policy."""

    return password_hasher.hash(password)


def verify_password(password: str, encoded_hash: str) -> bool:
    """Verify a password without exposing hash-format errors."""

    try:
        return password_hasher.verify(password, encoded_hash)
    except Exception:
        return False


def new_secret() -> str:
    """Return a URL-safe 256-bit random token."""

    return secrets.token_urlsafe(32)


def hash_secret(value: str) -> str:
    """Hash a session or CSRF token before database storage."""

    return hashlib.sha256(value.encode("utf-8")).hexdigest()


class MfaConfigurationError(RuntimeError):
    """Raised when the MFA encryption key is absent or invalid."""


def _fernet(encryption_key: str | None) -> Fernet:
    if not encryption_key:
        raise MfaConfigurationError("MFA encryption is not configured")
    try:
        return Fernet(encryption_key.encode("ascii"))
    except (UnicodeEncodeError, ValueError) as exc:
        raise MfaConfigurationError("The MFA encryption key is invalid") from exc


def encrypt_totp_secret(secret: str, encryption_key: str | None) -> str:
    """Encrypt one TOTP secret for storage."""

    return _fernet(encryption_key).encrypt(secret.encode("ascii")).decode("ascii")


def decrypt_totp_secret(ciphertext: str, encryption_key: str | None) -> str:
    """Decrypt one stored TOTP secret and fail closed on invalid data."""

    try:
        return _fernet(encryption_key).decrypt(ciphertext.encode("ascii")).decode("ascii")
    except (InvalidToken, UnicodeDecodeError, UnicodeEncodeError) as exc:
        raise MfaConfigurationError("The stored MFA secret cannot be decrypted") from exc


def new_totp_secret() -> str:
    """Return a random base32 TOTP secret."""

    return pyotp.random_base32()


def totp_provisioning_uri(secret: str, username: str, issuer: str) -> str:
    """Return the standard authenticator provisioning URI."""

    return pyotp.TOTP(secret).provisioning_uri(name=username, issuer_name=issuer)


def totp_qr_svg_data_uri(provisioning_uri: str) -> str:
    """Render a provisioning URI as an inline SVG data URI."""

    output = io.BytesIO()
    segno.make(provisioning_uri, error="m").save(
        output,
        kind="svg",
        scale=5,
        border=2,
        xmldecl=False,
    )
    encoded = base64.b64encode(output.getvalue()).decode("ascii")
    return f"data:image/svg+xml;base64,{encoded}"


def verify_totp_code(
    secret: str,
    code: str,
    last_used_step: int | None,
    now: datetime | None = None,
) -> int | None:
    """Return the matching TOTP step, accepting one step of clock drift.

    A step that has already authenticated cannot be replayed.
    """

    normalized = code.strip()
    if len(normalized) != 6 or not normalized.isdigit():
        return None
    current = now or datetime.now(UTC)
    if current.tzinfo is None:
        current = current.replace(tzinfo=UTC)
    totp = pyotp.TOTP(secret)
    current_step = int(current.timestamp()) // totp.interval
    for step in (current_step, current_step - 1, current_step + 1):
        if last_used_step is not None and step <= last_used_step:
            continue
        expected = totp.at(step * totp.interval)
        if secrets.compare_digest(expected, normalized):
            return step
    return None


RECOVERY_CODE_ALPHABET = "23456789ABCDEFGHJKLMNPQRSTUVWXYZ"


def new_recovery_codes(count: int = 10) -> list[str]:
    """Return single-use recovery codes formatted for human transcription."""

    codes: list[str] = []
    while len(codes) < count:
        compact = "".join(secrets.choice(RECOVERY_CODE_ALPHABET) for _ in range(12))
        code = f"{compact[:4]}-{compact[4:8]}-{compact[8:]}"
        if code not in codes:
            codes.append(code)
    return codes


def normalize_recovery_code(code: str) -> str:
    """Normalize a recovery code before comparison."""

    return code.strip().replace("-", "").replace(" ", "").upper()


def hash_recovery_code(code: str) -> str:
    """Hash one normalized recovery code for storage."""

    return hash_secret(normalize_recovery_code(code))


def login_subject_hash(username: str) -> str:
    """Return a non-reversible key for per-account login throttling."""

    return hash_secret(username.strip().casefold())
