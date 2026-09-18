/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_c_det
/// @author  Dhraax
/// modified by: Dhraax
/// @brief   Screen selector: a recipe is selected.
/// ----------------------------------------------------------------------------

#include "cnr_i_craft"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    if (GetLocalInt(oPC, CNR_VAR_RECIPE) <= 0)
    {
        return FALSE;
    }

    // Every return to detail reads the current shared station inventory.
    // Components are consumed before animation, so a craft's next detail
    // already shows the remaining quantities without a delayed token write.
    CnrCraft_SetDetailToken(oPC, GetLocalObject(oPC, CNR_VAR_PLACEABLE));

    CnrCraft_SetHeaderTokens(oPC);
    CnrCraft_SetButtonTokens();
    return TRUE;
}
