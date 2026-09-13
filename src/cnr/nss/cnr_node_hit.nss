/// ----------------------------------------------------------------------------
/// @system  CNR Harvesting
/// @file    cnr_node_hit
/// @author  Dhraax
/// @brief   OnMeleeAttacked of every harvesting node. One strike, one attempt.
///
///          It sits on the blueprint and not on the instance, so replicating
///          from the palette carries it to every node that is already placed.
/// ----------------------------------------------------------------------------

#include "cnr_i_node"

void main()
{
    object oPC = GetLastAttacker();

    if (!GetIsPC(oPC) || GetIsDM(oPC))
    {
        return;
    }

    CnrNode_Strike(oPC, OBJECT_SELF);
}
