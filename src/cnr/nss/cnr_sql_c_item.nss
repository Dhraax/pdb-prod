/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR)
//
//  Name:  cnr_sql_c_item
//
//  Desc:  Retired. Pre-crafting hook of the old station
//         scripts, which are themselves retired.
//
//         It resolved item properties from the tables
//         recipe_metadata and material_properties, seeded from
//         NWScript by cnr_sql_init. Neither the tables nor that
//         seed exist any more; the archived statements are in
//           migration/legacy-catalogue-seed.sql
//
//         Properties are now per recipe, in cnr_recipe_property,
//         and applied by cnr_apply_prop.nss.
//
//         Kept as an empty entry point so any stale
//         ExecuteScript("cnr_sql_c_item") still resolves.
//
//  Author: Dhraax
//
//  modified by: Dhraax
/////////////////////////////////////////////////////////

void main()
{
}
