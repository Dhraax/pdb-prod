/// ----------------------------------------------------------------------------
/// @system CNR_SQL_CRAFTING
/// @file cnr_sql_init.nss
/// @author Dhraax
/// @brief Retired. The crafting catalogue no longer loads from NWScript.
/// modified by: Dhraax
///
/// This script used to create the legacy tables recipe_metadata and
/// material_properties and reseed them with 706 hardcoded statements on every
/// module load. That work now belongs to the database: the catalogue lives in
/// cnr_recipe, cnr_recipe_component and cnr_recipe_property, authored in
/// migration/ and applied out of band with linux_apply_sql.sh.
///
/// The removed statements are archived verbatim in
///   migration/legacy-catalogue-seed.sql
/// and the current model is described in
///   documentation/oficios/cnr/schema.md
///
/// The file is kept as an empty entry point so that any lingering
/// ExecuteScript("cnr_sql_init") left in a module, area or placeable resolves
/// to a harmless no-op instead of a missing-script error. Retired CNR scripts
/// are gutted, never deleted.
/// ----------------------------------------------------------------------------

void main()
{
}
