/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_c_slot
/// @author  Dhraax
/// @brief   Shows list line "idx" when the current page has one.
/// ----------------------------------------------------------------------------

#include "cnr_i_craft"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nIdx = StringToInt(GetScriptParam("idx"));

    return CnrCraft_GetListEntry(oPC, nIdx) != "";
}
