"""Reserve the character rebuild cleanup migration boundary."""

from collections.abc import Sequence

revision: str = "0010_character_rebuild_cleanup"
down_revision: str | None = "0009_character_level_unlocks"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    """Keep the migration chain stable; runtime SQL owns revision cleanup."""


def downgrade() -> None:
    """No schema object is owned by this compatibility migration."""
