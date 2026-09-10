-- ---------------------------------------------------------------------------
--  Drop the tables of the retired NWScript-seeded crafting system.
--
--  Apply with:  ./linux_apply_sql.sh migration/04_drop_legacy.sql
--
--  Run once, after 01-03. Safe to re-run: every statement is IF EXISTS.
--
--  These three tables have no remaining reader:
--
--    recipe_metadata       Seeded from cnr_sql_init.nss at every module load
--    material_properties   and read only by cnr_sql_c_item.nss, the
--                          pre-crafting hook of the old station scripts.
--                          All of those are now empty stubs. Their contents
--                          are archived verbatim in
--                          migration/legacy-catalogue-seed.sql.
--
--    cnr_craft_selection   Was written only by cnr_at_r_craft.nss through the
--                          retired cnr_c_recipe conversation. Those runtime
--                          resources have since been removed. The new engine
--                          keeps the selection on the PC in CNR_VAR_RECIPE.
--                          It was empty.
--
--  The live catalogue is cnr_recipe, cnr_recipe_component and
--  cnr_recipe_property. Player state (pwdb_*, cnr_tradeskill,
--  cnr_character_setting) is not touched here.
-- ---------------------------------------------------------------------------

DROP TABLE IF EXISTS recipe_metadata;
DROP TABLE IF EXISTS material_properties;
DROP TABLE IF EXISTS cnr_craft_selection;
