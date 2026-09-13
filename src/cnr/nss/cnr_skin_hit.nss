/// ----------------------------------------------------------------------------
/// @system  CNR Harvesting
/// @file    cnr_skin_hit
/// @author  Dhraax
/// @brief   OnMeleeAttacked of the skinnable corpse. One strike, one attempt,
///          the same gesture that works a vein or a tree.
///
///          It sits on the blueprint and not on the instance, because the
///          corpse is created at runtime and never placed by hand.
/// ----------------------------------------------------------------------------
#include "cnr_i_skin"

void main()
{
    object oPC = GetLastAttacker();

    if (!GetIsPC(oPC) || GetIsDM(oPC))
    {
        return;
    }

    CnrSkin_Strike(oPC, OBJECT_SELF);
}
