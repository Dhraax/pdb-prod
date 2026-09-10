"""Versioned property definitions shared by validation and presentation."""

from typing import Any

from pydantic_core import PydanticCustomError

PROPERTY_DEFINITION_VERSION = 2


def _option(label: str, **values: int) -> dict[str, Any]:
    return {"label": label, "values": values}


def _select(key: str, label: str, options: list[dict[str, Any]]) -> dict[str, Any]:
    bindings = list(options[0]["values"]) if options else []
    return {
        "key": key,
        "label": label,
        "kind": "select",
        "bindings": bindings,
        "options": options,
    }


def _number(key: str, label: str, binding: str, minimum: int, maximum: int) -> dict[str, Any]:
    return {
        "key": key,
        "label": label,
        "kind": "number",
        "bindings": [binding],
        "minimum": minimum,
        "maximum": maximum,
    }


def _definition(
    property_type: str,
    label: str,
    description: str,
    defaults: dict[str, int],
    controls: list[dict[str, Any]],
    fixed: dict[str, int] | None = None,
) -> dict[str, Any]:
    return {
        "property_type": property_type,
        "label": label,
        "description": description,
        "defaults": defaults,
        "fixed": fixed or {},
        "controls": controls,
    }


DAMAGE_TYPES = [
    _option("Contundente", subtype=0),
    _option("Perforante", subtype=1),
    _option("Cortante", subtype=2),
    _option("No letal", subtype=3),
    _option("Físico directo", subtype=4),
    _option("Mágico", subtype=5),
    _option("Ácido", subtype=6),
    _option("Frío", subtype=7),
    _option("Divino", subtype=8),
    _option("Relámpago", subtype=9),
    _option("Fuego", subtype=10),
    _option("Necrótico", subtype=11),
    _option("Radiante", subtype=12),
    _option("Trueno", subtype=13),
    _option("Base", subtype=14),
    _option("Fuerza", subtype=16),
    _option("Veneno", subtype=17),
    _option("Psíquico", subtype=18),
]

RACES = [
    _option("Enano", subtype=0),
    _option("Elfo", subtype=1),
    _option("Gnomo", subtype=2),
    _option("Mediano", subtype=3),
    _option("Semielfo", subtype=4),
    _option("Semiorco", subtype=5),
    _option("Humano", subtype=6),
    _option("Aberración", subtype=7),
    _option("Animal", subtype=8),
    _option("Bestia", subtype=9),
    _option("Constructo", subtype=10),
    _option("Dragón", subtype=11),
    _option("Humanoide goblinoide", subtype=12),
    _option("Humanoide monstruoso", subtype=13),
    _option("Humanoide orco", subtype=14),
    _option("Humanoide reptiliano", subtype=15),
    _option("Elemental", subtype=16),
    _option("Fata", subtype=17),
    _option("Gigante", subtype=18),
    _option("Bestia mágica", subtype=19),
    _option("Ajeno", subtype=20),
    _option("Cambiaformas", subtype=23),
    _option("No muerto", subtype=24),
    _option("Alimaña", subtype=25),
    _option("Cieno", subtype=29),
    _option("Drider (custom)", subtype=50),
    _option("Wemic (custom)", subtype=51),
    _option("Planta (custom)", subtype=52),
    _option("Brownie (custom)", subtype=53),
]

ALIGNMENTS = [
    _option("Todos", subtype=0),
    _option("Neutral", subtype=1),
    _option("Legal", subtype=2),
    _option("Caótico", subtype=3),
    _option("Bueno", subtype=4),
    _option("Maligno", subtype=5),
]

SAVES = [
    _option("Universal", subtype=0),
    _option("Ácido", subtype=1),
    _option("Frío", subtype=3),
    _option("Muerte", subtype=4),
    _option("Enfermedad", subtype=5),
    _option("Divino", subtype=6),
    _option("Electricidad", subtype=7),
    _option("Miedo", subtype=8),
    _option("Fuego", subtype=9),
    _option("Afectación mental", subtype=11),
    _option("Energía negativa", subtype=12),
    _option("Veneno", subtype=13),
    _option("Energía positiva", subtype=14),
    _option("Sónico", subtype=15),
]

RAW_DAMAGE_AMOUNTS = [
    *[_option(f"+{amount}", value2=index) for amount, index in zip(range(1, 6), range(1, 6))],
    _option("+6", value2=16),
    _option("+7", value2=17),
    _option("+8", value2=18),
    _option("+9", value2=19),
    _option("+10", value2=20),
    _option("1d4", value2=6),
    _option("1d6", value2=7),
    _option("1d8", value2=8),
    _option("1d10", value2=9),
    _option("1d12", value2=14),
    _option("2d4", value2=12),
    _option("2d6", value2=10),
    _option("2d8", value2=11),
    _option("2d10", value2=13),
    _option("2d12", value2=15),
]

PLAIN_DAMAGE_AMOUNTS = [
    *[
        _option(f"+{amount}", value1=index, value2=0)
        for amount, index in zip(range(1, 6), range(1, 6))
    ],
    _option("+6", value1=16, value2=0),
    _option("+7", value1=17, value2=0),
    _option("+8", value1=18, value2=0),
    _option("+9", value1=19, value2=0),
    _option("+10", value1=20, value2=0),
    _option("1d4", value1=0, value2=4),
    _option("1d6", value1=0, value2=6),
    _option("1d8", value1=0, value2=8),
    _option("1d10", value1=0, value2=10),
    _option("1d12", value1=0, value2=12),
    _option("2d6", value1=0, value2=20),
]

IMMUNITIES = [
    _option("5 %", value1=1),
    _option("10 %", value1=2),
    _option("15 % (custom)", value1=9),
    _option("20 % (custom)", value1=8),
    _option("25 %", value1=3),
    _option("50 %", value1=4),
    _option("75 %", value1=5),
    _option("90 %", value1=6),
    _option("100 %", value1=7),
]

SPELL_FAILURE = [
    _option("-50 %", value1=0),
    _option("-30 %", value1=4),
    _option("-25 %", value1=5),
    _option("-20 %", value1=6),
]

SPELL_RESISTANCE = [
    _option(f"RC {resistance}", value1=index) for index, resistance in enumerate(range(10, 33, 2))
]

ON_HIT_SAVE_DC = [_option(f"CD {dc}", value1=index) for index, dc in enumerate(range(14, 27, 2))]

SPELLCASTING_CLASSES = [
    _option("Bardo", subtype=1),
    _option("Clérigo", subtype=2),
    _option("Druida", subtype=3),
    _option("Paladín", subtype=6),
    _option("Explorador", subtype=7),
    _option("Hechicero", subtype=9),
    _option("Mago", subtype=10),
]


PROPERTY_DEFINITIONS = [
    _definition(
        "DamageBonus",
        "Daño adicional",
        "Añade daño del tipo y cantidad elegidos.",
        {"subtype": 4, "value1": 1, "value2": 0},
        [
            _select("damage_type", "Tipo de daño", DAMAGE_TYPES),
            _select("amount", "Cantidad", PLAIN_DAMAGE_AMOUNTS),
        ],
    ),
    _definition(
        "DamageBonusOpposite",
        "Daño físico opuesto (automático)",
        "El script detecta el daño físico del arma y aplica automáticamente el opuesto.",
        {"subtype": 0, "value1": 1, "value2": 0},
        [_select("amount", "Cantidad", PLAIN_DAMAGE_AMOUNTS)],
        {"subtype": 0},
    ),
    _definition(
        "DamageBonusVsRace",
        "Daño adicional contra raza",
        "Añade daño solamente contra la raza seleccionada.",
        {"subtype": 17, "value1": 5, "value2": 6},
        [
            _select("race", "Raza", RACES),
            _select(
                "damage_type",
                "Tipo de daño",
                [
                    {"label": x["label"], "values": {"value1": x["values"]["subtype"]}}
                    for x in DAMAGE_TYPES
                ],
            ),
            _select("amount", "Cantidad", RAW_DAMAGE_AMOUNTS),
        ],
    ),
    _definition(
        "DamageBonusVsAlign",
        "Daño adicional contra alineamiento",
        "Añade daño solamente contra el grupo de alineamiento seleccionado.",
        {"subtype": 5, "value1": 12, "value2": 6},
        [
            _select("alignment", "Alineamiento", ALIGNMENTS),
            _select(
                "damage_type",
                "Tipo de daño",
                [
                    {"label": x["label"], "values": {"value1": x["values"]["subtype"]}}
                    for x in DAMAGE_TYPES
                ],
            ),
            _select("amount", "Cantidad", RAW_DAMAGE_AMOUNTS),
        ],
    ),
    _definition(
        "EnhancementBonus",
        "Bonificador de mejora",
        "Bonificador general de mejora del objeto.",
        {"subtype": 0, "value1": 1, "value2": 0},
        [_number("bonus", "Bonificador", "value1", 1, 20)],
        {"subtype": 0, "value2": 0},
    ),
    _definition(
        "EnhancementBonusVsRace",
        "Mejora contra raza",
        "Bonificador de mejora contra una raza.",
        {"subtype": 17, "value1": 1, "value2": 0},
        [_select("race", "Raza", RACES), _number("bonus", "Bonificador", "value1", 1, 20)],
        {"value2": 0},
    ),
    _definition(
        "EnhancementBonusVsAlign",
        "Mejora contra alineamiento",
        "Bonificador de mejora contra un alineamiento.",
        {"subtype": 5, "value1": 1, "value2": 0},
        [
            _select("alignment", "Alineamiento", ALIGNMENTS),
            _number("bonus", "Bonificador", "value1", 1, 20),
        ],
        {"value2": 0},
    ),
    _definition(
        "ACBonus",
        "Bonificador de CA",
        "Aumenta la clase de armadura.",
        {"subtype": 0, "value1": 1, "value2": 0},
        [_number("bonus", "Bonificador de CA", "value1", 1, 20)],
        {"subtype": 0, "value2": 0},
    ),
    _definition(
        "ACBonusVsRace",
        "CA contra raza",
        "Aumenta la CA contra una raza.",
        {"subtype": 17, "value1": 1, "value2": 0},
        [_select("race", "Raza", RACES), _number("bonus", "Bonificador de CA", "value1", 1, 20)],
        {"value2": 0},
    ),
    _definition(
        "ACBonusVsAlign",
        "CA contra alineamiento",
        "Aumenta la CA contra un alineamiento.",
        {"subtype": 5, "value1": 1, "value2": 0},
        [
            _select("alignment", "Alineamiento", ALIGNMENTS),
            _number("bonus", "Bonificador de CA", "value1", 1, 20),
        ],
        {"value2": 0},
    ),
    _definition(
        "DamageImmunity",
        "Inmunidad al daño",
        "Reduce un porcentaje del daño seleccionado.",
        {"subtype": 10, "value1": 2, "value2": 0},
        [
            _select("damage_type", "Tipo de daño", DAMAGE_TYPES),
            _select("percentage", "Porcentaje", IMMUNITIES),
        ],
        {"value2": 0},
    ),
    _definition(
        "SavingThrowBonusVs",
        "Salvación contra efecto",
        "Bonificador a las tiradas de salvación contra un efecto.",
        {"subtype": 0, "value1": 1, "value2": 0},
        [
            _select("save", "Tipo de salvación", SAVES),
            _number("bonus", "Bonificador", "value1", 1, 20),
        ],
        {"value2": 0},
    ),
    _definition(
        "SpellFailure",
        "Fallo de conjuro arcano",
        "Modifica el porcentaje de fallo de conjuro arcano.",
        {"subtype": 0, "value1": 4, "value2": 0},
        [_select("failure", "Modificación", SPELL_FAILURE)],
        {"subtype": 0, "value2": 0},
    ),
    _definition(
        "SpellResistance",
        "Resistencia a conjuros",
        "Otorga el valor de resistencia a conjuros seleccionado.",
        {"subtype": 0, "value1": 4, "value2": 0},
        [_select("resistance", "Resistencia", SPELL_RESISTANCE)],
        {"subtype": 0, "value2": 0},
    ),
    _definition(
        "Regeneration",
        "Regeneración",
        "Regenera puntos de golpe por asalto.",
        {"subtype": 0, "value1": 1, "value2": 0},
        [_number("amount", "PG por asalto", "value1", 1, 20)],
        {"subtype": 0, "value2": 0},
    ),
    _definition(
        "VampiricRegeneration",
        "Regeneración vampírica",
        "Cura al portador al infligir daño.",
        {"subtype": 0, "value1": 1, "value2": 0},
        [_number("amount", "Cantidad", "value1", 1, 20)],
        {"subtype": 0, "value2": 0},
    ),
    _definition(
        "Keen",
        "Afilada",
        "Duplica el rango de amenaza crítica.",
        {"subtype": 0, "value1": 0, "value2": 0},
        [],
        {"subtype": 0, "value1": 0, "value2": 0},
    ),
    _definition(
        "Stun",
        "Impacto: aturdir",
        "Intento de aturdir al objetivo al golpear.",
        {"subtype": 0, "value1": 0, "value2": 0},
        [_select("save_dc", "CD de salvación", ON_HIT_SAVE_DC)],
        {"subtype": 0, "value2": 0},
    ),
    _definition(
        "Silence",
        "Impacto: silencio",
        "Intento de silenciar al objetivo al golpear.",
        {"subtype": 0, "value1": 0, "value2": 0},
        [_select("save_dc", "CD de salvación", ON_HIT_SAVE_DC)],
        {"subtype": 0, "value2": 0},
    ),
    _definition(
        "BonusLevelSpell",
        "Espacios de conjuro adicionales",
        "Añade espacios consecutivos desde el nivel inicial.",
        {"subtype": 1, "value1": 1, "value2": 1},
        [
            _select("class", "Clase lanzadora", SPELLCASTING_CLASSES),
            _number("start_level", "Nivel inicial", "value1", 0, 9),
            _number("level_count", "Número de niveles", "value2", 1, 10),
        ],
    ),
]

PROPERTY_DEFINITIONS_BY_TYPE = {
    definition["property_type"]: definition for definition in PROPERTY_DEFINITIONS
}


def validate_property_values(property_type: str, subtype: int, value1: int, value2: int) -> None:
    """Reject property rows that the verified runtime consumer cannot interpret."""

    definition = PROPERTY_DEFINITIONS_BY_TYPE.get(property_type)
    if definition is None:
        raise PydanticCustomError(
            "unsupported_property_type",
            "El tipo de propiedad '{property_type}' no está soportado por el consumidor activo",
            {"property_type": property_type},
        )
    values = {"subtype": subtype, "value1": value1, "value2": value2}
    for binding, expected in definition["fixed"].items():
        if values[binding] != expected:
            raise PydanticCustomError(
                "invalid_property_value",
                "{binding} debe ser {expected} para {property_type}",
                {"binding": binding, "expected": expected, "property_type": property_type},
            )
    for control in definition["controls"]:
        if control["kind"] == "select":
            if not any(
                all(values[binding] == expected for binding, expected in option["values"].items())
                for option in control["options"]
            ):
                raise PydanticCustomError(
                    "invalid_property_option",
                    "Selección de {label} no válida para {property_type}",
                    {"label": control["label"], "property_type": property_type},
                )
        else:
            value = values[control["bindings"][0]]
            if value < control["minimum"] or value > control["maximum"]:
                raise PydanticCustomError(
                    "invalid_property_range",
                    "{label} debe estar entre {minimum} y {maximum}",
                    {
                        "label": control["label"],
                        "minimum": control["minimum"],
                        "maximum": control["maximum"],
                    },
                )
    if property_type == "BonusLevelSpell" and value1 + value2 > 10:
        raise PydanticCustomError(
            "invalid_spell_level_range",
            "El nivel final del espacio de conjuro adicional no puede superar 9",
        )


def describe_property_values(property_type: str, subtype: int, value1: int, value2: int) -> str:
    """Render a current property selection using its verified labels."""

    definition = PROPERTY_DEFINITIONS_BY_TYPE.get(property_type)
    if definition is None:
        return f"{property_type}: subtype={subtype}, value1={value1}, value2={value2}"
    values = {"subtype": subtype, "value1": value1, "value2": value2}
    labels = []
    for control in definition["controls"]:
        if control["kind"] == "select":
            selected = next(
                (
                    option["label"]
                    for option in control["options"]
                    if all(
                        values[binding] == expected
                        for binding, expected in option["values"].items()
                    )
                ),
                "Valor no reconocido",
            )
            labels.append(selected)
        else:
            labels.append(f"{control['label']} {values[control['bindings'][0]]:+d}")
    suffix = " · ".join(labels)
    return f"{definition['label']}: {suffix}" if suffix else definition["label"]
