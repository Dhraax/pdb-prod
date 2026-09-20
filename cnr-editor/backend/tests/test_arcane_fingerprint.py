"""Contract tests for the arcane concurrency token.

The arcane tables carry no updated_at, so the panel guards a concurrent edit
with a digest of the row and its steps instead. These tests pin the two
properties that makes it safe: it changes when anything editable changes, and
it does not change for anything else.
"""

from dataclasses import dataclass, field, replace

from app.arcane_fingerprint import arcane_fingerprint


@dataclass
class Step:
    essences: int
    subtype: int | None
    value1: int
    value2: int
    xp: int
    display_value: str


@dataclass
class Property:
    arcane_id: int = 1
    section: str = "HABILIDADES"
    display_name: str = "Piruetas"
    group_id: int = 1
    tier: int = 1
    essence_resref: str = "cnr_e_1"
    essence_name: str = "Bolsa viscosa"
    crystal_resref: str = "cnr_c_1"
    crystal_name: str = "Cristal menor"
    ubicacion: str = "Limo"
    property_type: str = "SkillBonus"
    subtype: int = 21
    min_level: int = 1
    dc: int = 10
    supported: bool = True
    note: str | None = None
    steps: list[Step] = field(default_factory=list)


def _property() -> Property:
    return Property(
        steps=[
            Step(essences=1, subtype=None, value1=1, value2=0, xp=4, display_value="+1"),
            Step(essences=2, subtype=None, value1=2, value2=0, xp=8, display_value="+2"),
        ]
    )


def test_same_content_gives_the_same_token() -> None:
    assert arcane_fingerprint(_property()) == arcane_fingerprint(_property())


def test_step_order_does_not_change_the_token() -> None:
    shuffled = _property()
    shuffled.steps = list(reversed(shuffled.steps))
    assert arcane_fingerprint(shuffled) == arcane_fingerprint(_property())


def test_every_editable_field_changes_the_token() -> None:
    base = _property()
    baseline = arcane_fingerprint(base)
    changes = {
        "section": "SALVACIONES",
        "display_name": "Otra cosa",
        "group_id": 2,
        "tier": 2,
        "essence_resref": "cnr_e_2",
        "essence_name": "Otra esencia",
        "crystal_resref": "cnr_c_2",
        "crystal_name": "Otro cristal",
        "ubicacion": "Otro sitio",
        "property_type": "AbilityBonus",
        "subtype": 22,
        "min_level": 2,
        "dc": 11,
        "supported": False,
        "note": "una nota",
    }
    for name, value in changes.items():
        assert arcane_fingerprint(replace(base, **{name: value})) != baseline, name


def test_a_changed_step_changes_the_token() -> None:
    baseline = arcane_fingerprint(_property())
    for name, value in (
        ("essences", 3),
        ("subtype", 7),
        ("value1", 9),
        ("value2", 9),
        ("xp", 99),
        ("display_value", "+9"),
    ):
        altered = _property()
        altered.steps[0] = replace(altered.steps[0], **{name: value})
        assert arcane_fingerprint(altered) != baseline, name


def test_adding_or_removing_a_step_changes_the_token() -> None:
    baseline = arcane_fingerprint(_property())

    added = _property()
    added.steps.append(Step(3, None, 3, 0, 12, "+3"))
    assert arcane_fingerprint(added) != baseline

    removed = _property()
    removed.steps.pop()
    assert arcane_fingerprint(removed) != baseline


def test_a_none_subtype_is_not_the_same_as_zero() -> None:
    explicit_zero = _property()
    explicit_zero.steps[0] = replace(explicit_zero.steps[0], subtype=0)
    assert arcane_fingerprint(explicit_zero) != arcane_fingerprint(_property())
