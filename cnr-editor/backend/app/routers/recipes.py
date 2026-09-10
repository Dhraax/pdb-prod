"""Authenticated catalogue browsing and transactional recipe editing."""

from datetime import UTC, datetime

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import String, cast, func, or_, select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session, selectinload

from app.database import get_db
from app.dependencies import (
    SessionContext,
    get_current_user,
    require_csrf,
    require_profession_edit,
    require_recipe_viewer,
    require_writes_enabled,
)
from app.models import (
    CatalogueRevision,
    Category,
    EditorUser,
    Material,
    Profession,
    Recipe,
    RecipeComponent,
    RecipeProperty,
    Station,
)
from app.property_definitions import PROPERTY_DEFINITIONS, PROPERTY_DEFINITION_VERSION
from app.property_labels import describe_property
from app.schemas import (
    ComponentOut,
    PropertyOut,
    PropertyDefinitionsOut,
    RecipeDetail,
    RecipeListItem,
    RecipeListPage,
    RecipeUpdate,
    ReferenceData,
    ReferenceItem,
)

router = APIRouter(tags=["catalogue"])


def _property_out(prop: RecipeProperty) -> PropertyOut:
    return PropertyOut(
        recipe_property_id=prop.recipe_property_id,
        property_type=prop.property_type,
        subtype=prop.subtype,
        value1=prop.value1,
        value2=prop.value2,
        sort_order=prop.sort_order,
        display_text=describe_property(prop),
    )


def _recipe_detail(recipe: Recipe) -> RecipeDetail:
    return RecipeDetail(
        recipe_id=recipe.recipe_id,
        public_id=recipe.public_id,
        category_id=recipe.category_id,
        material_id=recipe.material_id,
        tier=recipe.tier,
        display_name=recipe.display_name,
        description=recipe.description,
        base_resref=recipe.base_resref,
        output_tag=recipe.output_tag,
        output_qty=recipe.output_qty,
        output_kind=recipe.output_kind,
        dc=recipe.dc,
        xp_award=recipe.xp_award,
        gold_value=recipe.gold_value,
        enabled=recipe.enabled,
        legacy_code=recipe.legacy_code,
        created_at=recipe.created_at,
        updated_at=recipe.updated_at,
        components=[ComponentOut.model_validate(item) for item in recipe.components],
        properties=[_property_out(item) for item in recipe.properties],
    )


def _snapshot(recipe: Recipe) -> dict:
    return _recipe_detail(recipe).model_dump(mode="json")


@router.get("/property-definitions", response_model=PropertyDefinitionsOut)
def property_definitions(
    _: EditorUser = Depends(require_recipe_viewer),
) -> PropertyDefinitionsOut:
    return PropertyDefinitionsOut(
        version=PROPERTY_DEFINITION_VERSION,
        items=PROPERTY_DEFINITIONS,
    )


@router.get("/references", response_model=ReferenceData)
def references(
    _: EditorUser = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> ReferenceData:
    professions = list(db.scalars(select(Profession).order_by(Profession.profession_id)))
    stations = list(db.scalars(select(Station).order_by(Station.display_name)))
    categories = list(
        db.scalars(select(Category).order_by(Category.sort_order, Category.display_name))
    )
    materials = list(db.scalars(select(Material).order_by(Material.tier, Material.display_name)))
    return ReferenceData(
        professions=[
            ReferenceItem(id=x.profession_id, display_name=x.display_name) for x in professions
        ],
        stations=[
            ReferenceItem(
                id=x.station_id,
                display_name=x.display_name,
                profession_id=x.profession_id,
            )
            for x in stations
        ],
        categories=[
            ReferenceItem(
                id=x.category_id,
                display_name=x.display_name,
                parent_id=x.parent_id,
                station_id=x.station_id,
            )
            for x in categories
        ],
        materials=[
            ReferenceItem(
                id=x.material_id,
                display_name=x.display_name,
                profession_id=x.profession_id,
                tier=x.tier,
                enabled=x.enabled,
            )
            for x in materials
        ],
    )


@router.get("/recipes", response_model=RecipeListPage)
def list_recipes(
    _: EditorUser = Depends(require_recipe_viewer),
    db: Session = Depends(get_db),
    search: str | None = Query(default=None, max_length=96),
    profession_id: int | None = None,
    station_id: int | None = None,
    category_id: int | None = None,
    material_id: int | None = None,
    enabled: bool | None = None,
    offset: int = Query(default=0, ge=0),
    limit: int = Query(default=100, ge=1, le=250),
) -> RecipeListPage:
    component_count = (
        select(RecipeComponent.recipe_id, func.count().label("count"))
        .group_by(RecipeComponent.recipe_id)
        .subquery()
    )
    property_count = (
        select(RecipeProperty.recipe_id, func.count().label("count"))
        .group_by(RecipeProperty.recipe_id)
        .subquery()
    )
    query = (
        select(
            Recipe,
            Profession.profession_id,
            Profession.display_name,
            Station.display_name,
            Category.display_name,
            Material.display_name,
            func.coalesce(component_count.c.count, 0),
            func.coalesce(property_count.c.count, 0),
        )
        .join(Category, Recipe.category_id == Category.category_id)
        .join(Station, Category.station_id == Station.station_id)
        .join(Profession, Station.profession_id == Profession.profession_id)
        .outerjoin(Material, Recipe.material_id == Material.material_id)
        .outerjoin(component_count, component_count.c.recipe_id == Recipe.recipe_id)
        .outerjoin(property_count, property_count.c.recipe_id == Recipe.recipe_id)
    )
    conditions = []
    if search:
        pattern = f"%{search}%"
        conditions.append(
            or_(Recipe.display_name.like(pattern), cast(Recipe.public_id, String).like(pattern))
        )
    if profession_id is not None:
        conditions.append(Profession.profession_id == profession_id)
    if station_id is not None:
        conditions.append(Station.station_id == station_id)
    if category_id is not None:
        conditions.append(Category.category_id == category_id)
    if material_id is not None:
        conditions.append(Material.material_id == material_id)
    if enabled is not None:
        conditions.append(Recipe.enabled.is_(enabled))
    if conditions:
        query = query.where(*conditions)

    count_query = select(func.count()).select_from(query.order_by(None).subquery())
    total = db.scalar(count_query) or 0
    rows = db.execute(query.order_by(Recipe.public_id).offset(offset).limit(limit)).all()
    items = [
        RecipeListItem(
            recipe_id=row[0].recipe_id,
            public_id=row[0].public_id,
            display_name=row[0].display_name,
            profession_id=row[1],
            profession_name=row[2],
            station_name=row[3],
            category_name=row[4],
            material_name=row[5],
            tier=row[0].tier,
            dc=row[0].dc,
            xp_award=row[0].xp_award,
            gold_value=row[0].gold_value,
            enabled=row[0].enabled,
            component_count=row[6],
            property_count=row[7],
            updated_at=row[0].updated_at,
        )
        for row in rows
    ]
    return RecipeListPage(items=items, total=total, offset=offset, limit=limit)


@router.get("/recipes/{recipe_id}", response_model=RecipeDetail)
def get_recipe(
    recipe_id: int,
    _: EditorUser = Depends(require_recipe_viewer),
    db: Session = Depends(get_db),
) -> RecipeDetail:
    recipe = db.scalar(
        select(Recipe)
        .where(Recipe.recipe_id == recipe_id)
        .options(selectinload(Recipe.components), selectinload(Recipe.properties))
    )
    if recipe is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Receta no encontrada")
    return _recipe_detail(recipe)


@router.put(
    "/recipes/{recipe_id}",
    response_model=RecipeDetail,
    dependencies=[Depends(require_writes_enabled)],
)
def update_recipe(
    recipe_id: int,
    payload: RecipeUpdate,
    context: SessionContext = Depends(require_csrf),
    db: Session = Depends(get_db),
) -> RecipeDetail:
    recipe = db.scalar(
        select(Recipe)
        .where(Recipe.recipe_id == recipe_id)
        .with_for_update()
        .options(selectinload(Recipe.components), selectinload(Recipe.properties))
    )
    if recipe is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Receta no encontrada")

    current_profession_id = db.scalar(
        select(Station.profession_id)
        .join(Category, Category.station_id == Station.station_id)
        .where(Category.category_id == recipe.category_id)
    )
    target_profession_id = db.scalar(
        select(Station.profession_id)
        .join(Category, Category.station_id == Station.station_id)
        .where(Category.category_id == payload.category_id)
    )
    if current_profession_id is None or target_profession_id is None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="La receta o la categoría no pertenecen a un oficio válido",
        )
    require_profession_edit(context.user, current_profession_id)
    require_profession_edit(context.user, target_profession_id)

    supplied = payload.updated_at
    if supplied.tzinfo is not None:
        supplied = supplied.astimezone(UTC).replace(tzinfo=None)
    if recipe.updated_at != supplied:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="La receta cambió después de abrirla; recarga antes de guardar",
        )

    before = _snapshot(recipe)
    for field in (
        "public_id",
        "category_id",
        "material_id",
        "tier",
        "display_name",
        "description",
        "base_resref",
        "output_tag",
        "output_qty",
        "output_kind",
        "dc",
        "xp_award",
        "gold_value",
        "enabled",
    ):
        setattr(recipe, field, getattr(payload, field))

    try:
        recipe.components.clear()
        recipe.properties.clear()
        db.flush()
        recipe.components.extend(
            RecipeComponent(**item.model_dump()) for item in payload.components
        )
        recipe.properties.extend(RecipeProperty(**item.model_dump()) for item in payload.properties)
        recipe.updated_at = datetime.now(UTC).replace(tzinfo=None)
        db.flush()
        after = _snapshot(recipe)
        db.add(
            CatalogueRevision(
                recipe_id=recipe.recipe_id,
                actor_user_id=context.user.user_id,
                action="update",
                before_json=before,
                after_json=after,
            )
        )
        db.commit()
    except IntegrityError as exc:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="La receta incumple una restricción de unicidad o referencia del catálogo",
        ) from exc
    db.refresh(recipe)
    return _recipe_detail(recipe)
