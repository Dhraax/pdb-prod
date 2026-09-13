/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_c_start
/// @author  Dhraax
/// @brief   Conversation gate: refreshes the header tokens.
/// ----------------------------------------------------------------------------

#include "cnr_i_craft"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    if (GetLocalInt(oPC, CNR_VAR_STATION) <= 0)
    {
        return FALSE;
    }

    CnrCraft_SetHeaderTokens(oPC);
    CnrCraft_SetButtonTokens();
    CnrCraft_SetSlotTokens(oPC);
    return TRUE;
}
