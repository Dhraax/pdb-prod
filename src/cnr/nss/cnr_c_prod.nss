/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_c_prod
/// @author  Dhraax
/// @brief   Screen selector: browsing recipes.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "cnr_i_craft"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    CnrCraft_SetHeaderTokens(oPC);
    CnrCraft_SetButtonTokens();
    CnrCraft_SetSlotTokens(oPC);

    return GetLocalInt(oPC, CNR_VAR_LISTMODE) == CNR_LIST_RECIPES
        && !GetLocalInt(oPC, CNR_VAR_RECIPE);
}
