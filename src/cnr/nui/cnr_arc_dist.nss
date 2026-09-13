/// ----------------------------------------------------------------------------
/// @system  CNR Arcane
/// @file    cnr_arc_dist
/// @author  Dhraax
/// @brief   OnInvDisturbed of cnrArcaneTable. Re-reads the table whenever
///          something goes in or out: a different item changes which
///          properties are on offer, and the material counts move with it.
/// ----------------------------------------------------------------------------

#include "cnr_arc_nui"

void main()
{
    object oPC = GetLastDisturbed();
    if (!GetIsPC(oPC))
    {
        return;
    }
    CnrArcN_Refresh(oPC, OBJECT_SELF);
}
