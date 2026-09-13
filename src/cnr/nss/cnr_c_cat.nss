/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_c_cat
/// @author  Dhraax
/// @brief   Screen selector: browsing categories.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "cnr_i_craft"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    CnrCraft_SetHeaderTokens(oPC);
    CnrCraft_SetButtonTokens();
    CnrCraft_SetSlotTokens(oPC);

    return GetLocalInt(oPC, CNR_VAR_LISTMODE) == CNR_LIST_CATEGORIES
        && !GetLocalInt(oPC, CNR_VAR_RECIPE);
}
