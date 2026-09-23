"""Canonical CNR tradeskill labels and the live XP level curve."""

TRADESKILL_DEFINITIONS = (
    ("Herreria", "Herrería"),
    ("Carpinteria", "Carpintería"),
    ("Peleteria", "Peletería"),
    ("Alquimia", "Alquimia"),
    ("Joyeria", "Joyería"),
    ("Arcano", "Arcano"),
    ("Sastreria", "Sastrería"),
)

TRADESKILL_NAMES = tuple(name for name, _ in TRADESKILL_DEFINITIONS)
TRADESKILL_LABELS = dict(TRADESKILL_DEFINITIONS)

# Must match CnrTradeXPLevel1..20 in src/cnr/nss/cnr_trade_init.nss.
#
# It did not, from 2026-08-16 to 2026-08-20: the module halved the early
# curve and this copy kept the old 250..43000 one, so the panel derived a
# different level from the same XP and persisted it. It drifted again when the
# module moved to the 5000-XP curve on 2026-09-18 and this copy stayed on
# 25000. Whoever changes one changes both.
TRADESKILL_LEVEL_THRESHOLDS = (
    0,
    33,
    65,
    130,
    228,
    358,
    520,
    715,
    943,
    1203,
    1495,
    1820,
    2178,
    2568,
    3114,
    3705,
    4342,
    5018,
    5720,
    6500,
)


def tradeskill_level_from_xp(skill_xp: int) -> int:
    """Apply the same descending threshold lookup as NWScript persistence."""
    for level in range(len(TRADESKILL_LEVEL_THRESHOLDS), 0, -1):
        if skill_xp >= TRADESKILL_LEVEL_THRESHOLDS[level - 1]:
            return level
    return 1
