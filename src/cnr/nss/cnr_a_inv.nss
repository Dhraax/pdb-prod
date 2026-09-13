/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_a_inv
/// @author  Dhraax
/// @brief   Opens the station inventory. Closes the menu by design.
/// ----------------------------------------------------------------------------

#include "cnr_i_craft"

void main()
{
    object oPC = GetPCSpeaker();
    object oStation = GetLocalObject(oPC, CNR_VAR_PLACEABLE);

    if (!GetIsObjectValid(oStation))
    {
        return;
    }

    // Opening the container fires OnUsed again. Clearing the pending flag makes
    // that count as the "open" half, so the menu returns when the player closes
    // it. Restoring the menu on top is deliberately not attempted.
    DeleteLocalInt(oStation, "CNR_MENU_PENDIENTE");
    AssignCommand(oPC, ActionInteractObject(oStation));
}
