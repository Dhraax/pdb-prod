"""Contract tests for the guided recipe property catalogue."""

import pytest
from pydantic_core import PydanticCustomError

from app.property_definitions import (
    PROPERTY_DEFINITIONS,
    PROPERTY_DEFINITION_VERSION,
    validate_property_values,
)
from app.schemas import PropertyDefinitionsOut


def _validate(values: dict[str, int], property_type: str) -> None:
    validate_property_values(
        property_type,
        values["subtype"],
        values["value1"],
        values["value2"],
    )


def test_every_definition_default_is_valid() -> None:
    for definition in PROPERTY_DEFINITIONS:
        _validate(definition["defaults"], definition["property_type"])


def test_catalogue_serializes_as_the_public_api_contract() -> None:
    response = PropertyDefinitionsOut(
        version=PROPERTY_DEFINITION_VERSION,
        items=PROPERTY_DEFINITIONS,
    )

    assert response.version == 2
    assert len(response.items) == 20


def test_duplicate_physical_2da_row_is_not_editable() -> None:
    with pytest.raises(PydanticCustomError, match="Tipo de daño no válida"):
        validate_property_values("DamageBonus", 15, 1, 0)


def test_every_select_option_is_valid_with_its_definition_defaults() -> None:
    for definition in PROPERTY_DEFINITIONS:
        for control in definition["controls"]:
            if control["kind"] != "select":
                continue
            for option in control["options"]:
                values = definition["defaults"] | option["values"]
                _validate(values, definition["property_type"])


def test_unsupported_property_type_is_rejected() -> None:
    with pytest.raises(PydanticCustomError, match="no está soportado"):
        validate_property_values("UnknownProperty", 0, 0, 0)


def test_unknown_plain_damage_encoding_is_rejected() -> None:
    with pytest.raises(PydanticCustomError, match="Cantidad no válida"):
        validate_property_values("DamageBonus", 10, 99, 0)


def test_bonus_spell_levels_cannot_extend_past_level_nine() -> None:
    with pytest.raises(PydanticCustomError, match="no puede superar 9"):
        validate_property_values("BonusLevelSpell", 10, 9, 2)
