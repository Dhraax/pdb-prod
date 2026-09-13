/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx & Hrnac
//
//  Name:  cnr_recipe_init
//
//  Desc:  Recipe initialization. This script is
//         executed from "cnr_module_oml".
//
//  Author: David Bobeck 05Dec02
//  Modified: Gary Corcoran 05Aug03
//
//  modified by: Dhraax
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

/////////////////////////////////////////////////////////
void TestIfDeviceRecipesHaveBeenLoaded()
{
  int nStackCount = CnrGetStackCount(GetModule());
  if (nStackCount > 0)
  {
    AssignCommand(OBJECT_SELF, TestIfDeviceRecipesHaveBeenLoaded());
  }
  else
  {
    CnrWriteAllDevicesToSqlDatabase();

    // Setting this flag is not time critical.
    CnrSetPersistentInt(OBJECT_SELF, "CnrBoolBuildRecipeDatabase", 0);
  }
}

/////////////////////////////////////////////////////////
void main()
{
  PrintString("cnr_recipe_init");

  // This initializes the CNR tradeskills extension
  ExecuteScript("cnr_trade_init", OBJECT_SELF);

  // The newline char for use in convo dialogs since
  // carriage returns produce ugly boxes.
  SetCustomToken(500, "\n");

  // CNR version string
  SetCustomToken(501, "V1.5");

  // This initializes the CNR to HC-HTF conversion table
  ExecuteScript("cnr_hchtf_init", OBJECT_SELF);

  // Module builders: You should add your crafting devices
  // to the file "user_recipe_init" so that future versions
  // of CNR don't over-write your work.
  ExecuteScript("user_recipe_init", OBJECT_SELF);

  // Crafting devices are no longer registered here.
  //
  // Registering a device made this script execute its recipe file, seeding
  // hundreds of module local variables on every module load. The catalogue now
  // lives in MySQL (cnr_recipe and friends) and is read by cnr_i_craft.nss, so
  // that work fed nothing.
  //
  // Authored source: migration/catalogue/*.json
  // Plan:            documentation/oficios/cnr/catalogue-authoring-plan.md
  //
  // Removed: cnrForgePublic, cnrIngotRecycler, cnrAnvilSmith, cnrAlchemyTable,
  // cnrHebCauldron, cnrJewelersBench, cnrTailorsTable, cnrCuringTub,
  // cnrCarpsBench, cnrEnchantAltar, cnrEnchantStatue, cnrEnchantPool.
  //
  // Everything else in this file stays: cnr_trade_init defines the
  // CnrTradeXPLevel1..20 curve the tradeskill book reads, and tokens 500/501
  // are used by the CNR conversations.

  // Power builders that want to store their recipes in a persistent db
  // so they can be tweaked without restarting the game sever must first get the
  // recipes into the db. By setting "CnrBoolBuildRecipeDatabase" to 1 in
  // the cnr_misc table, CNR will use APS to load all scripted recipe data into a
  // SQL database in OnModuleLoad. Once the data is written, "CnrBoolBuildRecipeDatabase"
  // will be automatically be zeroed
  int bBuildRecipeDatabase = CnrGetPersistentInt(OBJECT_SELF, "CnrBoolBuildRecipeDatabase");
  if (bBuildRecipeDatabase == TRUE)
  {
    // this call is asynchronous - it uses AssignCommand to avoid TMI
    CnrLoadAllDeviceRecipesFromScript();

    // wait until initialization is done before continuing
    AssignCommand(OBJECT_SELF, TestIfDeviceRecipesHaveBeenLoaded());
  }
  else
  {
    int bRecipeDataIsPersistent = CnrGetPersistentInt(OBJECT_SELF, "CnrBoolRecipeDataIsPersistent");
    int bRecipeDataIsPersistentInSqlDatabase = bRecipeDataIsPersistent || CNR_BOOL_RECIPE_DATA_IS_PERSISTENT_IN_SQL_DATABASE;

    int bInitRecipesOnModuleLoad = CnrGetPersistentInt(OBJECT_SELF, "CnrBoolInitRecipesOnModuleLoad");
    bInitRecipesOnModuleLoad = bInitRecipesOnModuleLoad || CNR_BOOL_INIT_RECIPES_ON_MODULE_LOAD;

    if (bRecipeDataIsPersistentInSqlDatabase == TRUE)
    {
      if (bInitRecipesOnModuleLoad == TRUE)
      {
        // Load locals from database
        CnrReadAllDevicesFromSqlDatabase();
      }
    }
    else
    {
      if (bInitRecipesOnModuleLoad == TRUE)
      {
        // this call is asynchronous - it uses stack helpers to avoid TMI
        CnrLoadAllDeviceRecipesFromScript();
      }
    }
  }
}
