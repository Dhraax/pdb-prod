/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_module_oml
//
//  Desc:  This script must be run by the module's
//         OnModuleLoad event handler.
//
//  Author: David Bobeck 12Jan03
//
/////////////////////////////////////////////////////////
#include "cnr_persist_inc"
#include "cnr_config_inc"

void main()
{

  PrintString("Launching cnr_recipe_init");
  ExecuteScript("cnr_recipe_init", OBJECT_SELF);

  PrintString("Launching cnr_plant_init");
  ExecuteScript("cnr_plant_init", OBJECT_SELF);

  PrintString("Launching cnr_source_init");
  ExecuteScript("cnr_source_init", OBJECT_SELF);

}
