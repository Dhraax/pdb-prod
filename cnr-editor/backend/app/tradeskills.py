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
# different level from the same XP and persisted it. Whoever changes one
# changes both.
TRADESKILL_LEVEL_THRESHOLDS = (
    0,
    125,
    250,
    500,
    875,
    1375,
    2000,
    2750,
    3625,
    4625,
    5750,
    7000,
    8375,
    9875,
    11975,
    14250,
    16700,
    19300,
    22000,
    25000,
)


def tradeskill_level_from_xp(skill_xp: int) -> int:
    """Apply the same descending threshold lookup as NWScript persistence."""
    for level in range(len(TRADESKILL_LEVEL_THRESHOLDS), 0, -1):
        if skill_xp >= TRADESKILL_LEVEL_THRESHOLDS[level - 1]:
            return level
    return 1
