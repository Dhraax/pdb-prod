/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_a_browse
/// @author  Dhraax
/// @brief   Enters the top-level category list.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "cnr_i_craft"

void main()
{
    object oPC = GetPCSpeaker();

    DeleteLocalInt(oPC, CNR_VAR_RECIPE);
    DeleteLocalInt(oPC, CNR_VAR_VARIANT);
    DeleteLocalString(oPC, CNR_VAR_VGROUP);
    SetLocalInt(oPC, CNR_VAR_PAGE, 0);
    CnrCraft_ListCategories(oPC, 0);
    CnrCraft_SetSlotTokens(oPC);
}
