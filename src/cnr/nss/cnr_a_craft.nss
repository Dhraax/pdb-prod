/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_a_craft
/// @author  Dhraax
/// @brief   Runs the craft attempt.
/// ----------------------------------------------------------------------------

#include "cnr_i_craft"

void main()
{
    object oPC = GetPCSpeaker();

    CnrCraft_Attempt(oPC, GetLocalObject(oPC, CNR_VAR_PLACEABLE));
}
