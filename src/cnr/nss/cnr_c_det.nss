/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_c_det
/// @author  Dhraax
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

    CnrCraft_SetHeaderTokens(oPC);
    CnrCraft_SetButtonTokens();
    return TRUE;
}
