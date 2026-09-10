"""Human-readable labels for verified item-property rows."""

from app.models import RecipeProperty
from app.property_definitions import describe_property_values


def describe_property(prop: RecipeProperty) -> str:
    """Render a persisted property row through the versioned definition catalogue."""

    return describe_property_values(
        prop.property_type,
        prop.subtype,
        prop.value1,
        prop.value2,
    )
