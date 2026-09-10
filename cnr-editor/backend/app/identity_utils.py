"""Pure helpers for account and character administration."""


def identity_hint(value: str, visible: int = 4) -> str:
    """Mask an identity key while retaining a short administrative hint."""

    if len(value) <= visible * 2:
        return "•" * len(value)
    return f"{value[:visible]}…{value[-visible:]}"
