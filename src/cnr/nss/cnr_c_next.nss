/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_c_next
/// @author  Dhraax
/// @brief   Shows [next page] when another page exists.
/// ----------------------------------------------------------------------------

#include "cnr_i_craft"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    // Set by the listing when an extra row came back, so the button never
    // survives past the last page.
    return GetLocalInt(oPC, CNR_VAR_HAYMAS);
}
