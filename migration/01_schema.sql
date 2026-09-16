-- ---------------------------------------------------------------------------
--  CNR crafting catalogue - schema
--
--  Apply with:  ./linux_apply_sql.sh migration/01_schema.sql
--
--  Player state (pwdb_account, pwdb_character, cnr_tradeskill and settings)
--  is owned by migration/{pwdb,cnr}/ and is NOT touched here.
-- ---------------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS cnr_variant;
DROP TABLE IF EXISTS cnr_recipe_property;
DROP TABLE IF EXISTS cnr_recipe_component;
DROP TABLE IF EXISTS cnr_recipe;
DROP TABLE IF EXISTS cnr_material;
DROP TABLE IF EXISTS cnr_category;
DROP TABLE IF EXISTS cnr_station_tool;
DROP TABLE IF EXISTS cnr_station;
DROP TABLE IF EXISTS cnr_profession;
SET FOREIGN_KEY_CHECKS = 1;

-- --------------------------------------------------------------------------
CREATE TABLE cnr_profession (
  profession_id TINYINT UNSIGNED   NOT NULL,
  code          VARCHAR(16)        NOT NULL,
  display_name  VARCHAR(48)        NOT NULL,
  skill_index   TINYINT            NOT NULL,  -- GetSkillName(), 0-based
  ability_1     TINYINT            NULL,      -- ABILITY_* constant
  ability_2     TINYINT            NULL,      -- averaged with ability_1
  id_block      MEDIUMINT UNSIGNED NOT NULL,  -- public id range base
  PRIMARY KEY (profession_id),
  UNIQUE KEY uq_profession_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------------------------
CREATE TABLE cnr_station (
  station_id    SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  tag           VARCHAR(32)       NOT NULL,  -- placeable tag
  profession_id TINYINT UNSIGNED  NOT NULL,
  display_name  VARCHAR(48)       NOT NULL,
  produces      ENUM('product','material') NOT NULL DEFAULT 'product',
  anim_script   VARCHAR(16)       NULL,
  PRIMARY KEY (station_id),
  UNIQUE KEY uq_station_tag (tag),
  CONSTRAINT fk_station_profession
    FOREIGN KEY (profession_id) REFERENCES cnr_profession(profession_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------------------------
CREATE TABLE cnr_category (
  category_id  SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  station_id   SMALLINT UNSIGNED NOT NULL,
  parent_id    SMALLINT UNSIGNED NULL,      -- NULL = top level
  display_name VARCHAR(48)       NOT NULL,
  sort_order   SMALLINT          NOT NULL DEFAULT 0,
  PRIMARY KEY (category_id),
  KEY idx_category_browse (station_id, parent_id, sort_order),
  CONSTRAINT fk_category_station
    FOREIGN KEY (station_id) REFERENCES cnr_station(station_id) ON DELETE CASCADE,
  CONSTRAINT fk_category_parent
    FOREIGN KEY (parent_id) REFERENCES cnr_category(category_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------------------------
CREATE TABLE cnr_station_tool (
  station_tool_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  station_id      SMALLINT UNSIGNED NOT NULL,
  tool_tag        VARCHAR(32)       NOT NULL,
  display_name    VARCHAR(96)       NULL,   -- shown to the player, not the tag
  -- NULL means the whole station. A category id narrows the tool to one menu,
  -- which is how the jeweller's cutting kit is required for cutting gems and
  -- not for setting them.
  category_id     SMALLINT UNSIGNED NULL,
  access_mode     ENUM('equipped','inventory') NOT NULL,
  breakage_chance DECIMAL(5,2)      NOT NULL DEFAULT 0,
  sort_order      TINYINT           NOT NULL DEFAULT 0,
  PRIMARY KEY (station_tool_id),
  UNIQUE KEY uq_station_tool (station_id, tool_tag, category_id),
  CONSTRAINT fk_station_tool_station
    FOREIGN KEY (station_id) REFERENCES cnr_station(station_id) ON DELETE CASCADE,
  CONSTRAINT fk_station_tool_category
    FOREIGN KEY (category_id) REFERENCES cnr_category(category_id) ON DELETE CASCADE,
  CONSTRAINT chk_station_tool_breakage
    CHECK (breakage_chance >= 0 AND breakage_chance <= 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------------------------
CREATE TABLE cnr_material (
  material_id   SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  profession_id TINYINT UNSIGNED  NOT NULL,
  code          VARCHAR(48)       NOT NULL,
  display_name  VARCHAR(48)       NOT NULL,
  tier          TINYINT           NOT NULL,   -- 1..4
  sort_order    SMALLINT          NOT NULL,   -- position in the design table
  enabled       TINYINT(1)        NOT NULL DEFAULT 1,
  PRIMARY KEY (material_id),
  UNIQUE KEY uq_material_code (profession_id, code),
  KEY idx_material_tier (profession_id, tier, sort_order),
  CONSTRAINT fk_material_profession
    FOREIGN KEY (profession_id) REFERENCES cnr_profession(profession_id),
  CONSTRAINT chk_material_tier CHECK (tier BETWEEN 1 AND 4)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------------------------
CREATE TABLE cnr_recipe (
  recipe_id    MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  public_id    MEDIUMINT UNSIGNED NOT NULL,   -- what the player types
  category_id  SMALLINT UNSIGNED  NOT NULL,
  material_id  SMALLINT UNSIGNED  NULL,       -- NULL for potions and poisons
  tier         TINYINT            NOT NULL,
  -- What the menu may show. The tier gates material and DC in blocks of five
  -- levels, which opened a quarter of a profession the moment you reached it;
  -- this opens recipes one or two at a time instead.
  min_level    TINYINT            NOT NULL DEFAULT 1,
  display_name VARCHAR(96)        NOT NULL,   -- keeps palette colour codes
  description  VARCHAR(255)       NULL,
  base_resref  VARCHAR(16)        NOT NULL,   -- CreateItemOnObject blueprint resref
  output_tag   VARCHAR(32)        NULL,       -- tag applied to the result
  output_qty   SMALLINT           NOT NULL DEFAULT 1,
  output_kind  ENUM('product','material') NOT NULL DEFAULT 'product',
  -- Second product, created on success only and never instead of the main one.
  -- One extra is enough for every recipe that has one, so it lives here rather
  -- than in a child table; extra_name is what the recipe list shows, because a
  -- resref is not something a player should ever read.
  extra_resref VARCHAR(16)        NULL,
  extra_qty    SMALLINT           NOT NULL DEFAULT 0,
  extra_name   VARCHAR(96)        NULL,
  -- The result already holds a gem, so no recipe may take it as a component
  -- again. The engine marks the crafted item; the mark is what recipes read.
  marks_socketed TINYINT(1)       NOT NULL DEFAULT 0,
  -- Which trade made the item, stamped onto it as CNR_OFICIO so a later
  -- enchanting table can tell a crafted piece from anything else. 0 means the
  -- recipe makes no such piece: potions, and anything another recipe consumes.
  crafted_by   TINYINT UNSIGNED   NOT NULL DEFAULT 0,
  dc           SMALLINT           NOT NULL,
  xp_award     MEDIUMINT          NOT NULL,
  gold_value   MEDIUMINT          NOT NULL DEFAULT 0,
  enabled      TINYINT(1)         NOT NULL DEFAULT 1,
  -- When set, the product is not base_resref but the variant the player picks
  -- from this group. It is what keeps a recipe per material from becoming a
  -- recipe per product: a dagger and a mace of the same steel differ in
  -- nothing else.
  variant_group VARCHAR(32)       NULL,
  legacy_code  VARCHAR(64)        NULL,       -- old recipeId, transition only
  created_at   DATETIME           NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   DATETIME           NOT NULL DEFAULT CURRENT_TIMESTAMP
                                     ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (recipe_id),
  UNIQUE KEY uq_recipe_public (public_id),
  KEY idx_recipe_browse (category_id, enabled, dc),
  KEY idx_recipe_variant (variant_group),
  KEY idx_recipe_legacy (legacy_code),
  CONSTRAINT fk_recipe_category
    FOREIGN KEY (category_id) REFERENCES cnr_category(category_id),
  CONSTRAINT fk_recipe_material
    FOREIGN KEY (material_id) REFERENCES cnr_material(material_id),
  CONSTRAINT chk_recipe_tier CHECK (tier BETWEEN 1 AND 4),
  CONSTRAINT chk_recipe_output_qty CHECK (output_qty > 0),
  CONSTRAINT chk_recipe_extra
    CHECK ((extra_resref IS NULL AND extra_qty = 0)
        OR (extra_resref IS NOT NULL AND extra_qty > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------------------------
-- The products a recipe can turn out. A recipe naming a group offers these and
-- makes the one the player chooses; the chosen row is what supplies the
-- blueprint, so nothing the client sends is ever used as a resref.
--
-- The group is a plain string and not anything about weapons: the same pattern
-- fits the shields, helmets and armours that already repeat once per metal.
CREATE TABLE cnr_variant (
  variant_id   SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  group_code   VARCHAR(32)       NOT NULL,
  base_resref  VARCHAR(16)       NOT NULL,
  display_name VARCHAR(96)       NOT NULL,
  sort_order   SMALLINT          NOT NULL DEFAULT 0,
  PRIMARY KEY (variant_id),
  UNIQUE KEY uq_variant_product (group_code, base_resref),
  KEY idx_variant_group (group_code, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------------------------
CREATE TABLE cnr_recipe_component (
  recipe_id         MEDIUMINT UNSIGNED NOT NULL,
  component_tag     VARCHAR(32)        NOT NULL,
  display_name      VARCHAR(96)        NULL,   -- palette name, including colour codes
  qty               SMALLINT           NOT NULL DEFAULT 1,
  retain_on_fail    SMALLINT           NOT NULL DEFAULT 0,
  -- Survives a successful craft too: a reusable tool listed as a component,
  -- which is how the legacy biproduct mechanic is expressed.
  retain_on_success SMALLINT           NOT NULL DEFAULT 0,
  sort_order        TINYINT            NOT NULL DEFAULT 0,
  PRIMARY KEY (recipe_id, component_tag),
  CONSTRAINT fk_component_recipe
    FOREIGN KEY (recipe_id) REFERENCES cnr_recipe(recipe_id) ON DELETE CASCADE,
  CONSTRAINT chk_component_qty CHECK (qty > 0),
  CONSTRAINT chk_component_retain
    CHECK (retain_on_fail >= 0 AND retain_on_fail <= qty),
  CONSTRAINT chk_component_retain_ok
    CHECK (retain_on_success >= 0 AND retain_on_success <= qty)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------------------------
CREATE TABLE cnr_recipe_property (
  recipe_property_id MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  recipe_id     MEDIUMINT UNSIGNED NOT NULL,
  property_type VARCHAR(32)        NOT NULL,
  subtype       INT                NOT NULL DEFAULT 0,
  value1        INT                NOT NULL DEFAULT 0,
  value2        INT                NOT NULL DEFAULT 0,
  sort_order    TINYINT            NOT NULL DEFAULT 0,
  PRIMARY KEY (recipe_property_id),
  KEY idx_property_recipe (recipe_id, sort_order),
  CONSTRAINT fk_property_recipe
    FOREIGN KEY (recipe_id) REFERENCES cnr_recipe(recipe_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------
--  Arcane enchanting. A separate subsystem: it does not create items, it takes
--  one the player already owns and adds a property, so none of the cnr_recipe
--  columns fit. The NUI builds the request and the applier revalidates it
--  against these tables, which are the only authority on what is legal.
--
--  Generated by migration/build_arcane.py from documentation/oficios/arcano.json.
-- ---------------------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS cnr_arcane_step;
DROP TABLE IF EXISTS cnr_arcane_property;
DROP TABLE IF EXISTS cnr_arcane_group_base;
DROP TABLE IF EXISTS cnr_arcane_group;
SET FOREIGN_KEY_CHECKS = 1;

-- --------------------------------------------------------------------------
--  Which items a property may be applied to, by base item type rather than by
--  resref: a resref list needs maintaining and goes stale the first time
--  someone adds a blueprint and forgets to record it.
CREATE TABLE cnr_arcane_group (
  group_id     SMALLINT UNSIGNED NOT NULL,
  code         VARCHAR(32)       NOT NULL,
  display_name VARCHAR(96)       NOT NULL,
  -- 1 means every base item qualifies and cnr_arcane_group_base is not read.
  any_base     TINYINT(1)        NOT NULL DEFAULT 0,
  PRIMARY KEY (group_id),
  UNIQUE KEY uq_arcane_group_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------------------------
CREATE TABLE cnr_arcane_group_base (
  group_id     SMALLINT UNSIGNED NOT NULL,
  -- BASE_ITEM_* value. 361 is this server's leather belt and has no constant.
  base_item    SMALLINT          NOT NULL,
  -- Massive criticals costs two crystals on rapiers, kukris and scimitars;
  -- everything else costs one.
  crystal_cost TINYINT UNSIGNED  NOT NULL DEFAULT 1,
  PRIMARY KEY (group_id, base_item),
  CONSTRAINT fk_arcane_base_group
    FOREIGN KEY (group_id) REFERENCES cnr_arcane_group(group_id) ON DELETE CASCADE,
  CONSTRAINT chk_arcane_crystal_cost CHECK (crystal_cost > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------------------------
CREATE TABLE cnr_arcane_property (
  arcane_id      SMALLINT UNSIGNED NOT NULL,
  section        VARCHAR(32)       NOT NULL,   -- design family, for the UI
  display_name   VARCHAR(96)       NOT NULL,
  group_id       SMALLINT UNSIGNED NOT NULL,
  tier           TINYINT           NOT NULL,   -- 1..4, from the loot rarity
  essence_resref VARCHAR(16)       NOT NULL,   -- cnr_esen*, tag = resref
  essence_name   VARCHAR(96)       NOT NULL,   -- como lo ve el jugador
  crystal_resref VARCHAR(16)       NOT NULL,   -- cnr_c_1..6
  crystal_name   VARCHAR(96)       NOT NULL,
  -- Donde cae la esencia, tal cual lo escribio el diseno. La ventana lo
  -- muestra para que el jugador sepa que romper.
  ubicacion      VARCHAR(96)       NOT NULL DEFAULT '',
  property_type  VARCHAR(32)       NOT NULL,   -- as material-properties-reference.md
  subtype        INT               NOT NULL DEFAULT 0,
  min_level      TINYINT           NOT NULL,
  dc             SMALLINT          NOT NULL,
  -- 0 while no property consumer implements property_type. The UI must hide
  -- these: the craft would succeed and hand back an item with nothing on it.
  supported      TINYINT(1)        NOT NULL DEFAULT 1,
  note           VARCHAR(255)      NULL,
  PRIMARY KEY (arcane_id),
  KEY idx_arcane_browse (supported, tier, min_level),
  CONSTRAINT fk_arcane_property_group
    FOREIGN KEY (group_id) REFERENCES cnr_arcane_group(group_id),
  CONSTRAINT chk_arcane_tier CHECK (tier BETWEEN 1 AND 4)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------------------------
--  One row per amount the player may buy. Steps rather than a formula because
--  the ladders are not uniform: skills go one for one, immunities in fives,
--  and weapon damage skips the values NWN has no constant for.
CREATE TABLE cnr_arcane_step (
  arcane_id     SMALLINT UNSIGNED NOT NULL,
  essences      TINYINT UNSIGNED  NOT NULL,   -- how many of essence_resref
  -- Usually the property's own subtype applies. Damage reduction is the
  -- exception: its soak is fixed and what the essences buy is the enhancement
  -- needed to pierce it, so the step overrides it. NULL means "use the row's".
  subtype       INT               NULL,
  value1        INT               NOT NULL DEFAULT 0,
  value2        INT               NOT NULL DEFAULT 0,
  xp            MEDIUMINT         NOT NULL,   -- scales with what was spent
  display_value VARCHAR(32)       NOT NULL,   -- "+3", "20%", "1d8"
  PRIMARY KEY (arcane_id, essences),
  CONSTRAINT fk_arcane_step_property
    FOREIGN KEY (arcane_id) REFERENCES cnr_arcane_property(arcane_id) ON DELETE CASCADE,
  CONSTRAINT chk_arcane_step_essences CHECK (essences > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
