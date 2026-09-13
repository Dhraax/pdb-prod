/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_c_var
/// @author  Dhraax
/// @brief   Screen selector: the recipe offers several products and none has
///          been picked yet.
///
///          This screen only exists for recipes that name a variant group. A
///          recipe with a fixed product never reaches it and the menu behaves
///          exactly as it always did.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "cnr_i_craft"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    if (GetLocalInt(oPC, CNR_VAR_LISTMODE) != CNR_LIST_VARIANTS)
    {
        return FALSE;
    }
    if (GetLocalInt(oPC, CNR_VAR_RECIPE) <= 0)
    {
        return FALSE;
    }
    if (GetLocalInt(oPC, CNR_VAR_VARIANT) > 0)
    {
        return FALSE;
    }

    CnrCraft_SetHeaderTokens(oPC);
    CnrCraft_SetButtonTokens();
    CnrCraft_SetSlotTokens(oPC);
    return TRUE;
}
