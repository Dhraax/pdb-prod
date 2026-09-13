/// ----------------------------------------------------------------------------
/// @system  CNR Arcane
/// @file    cnr_arc_ou
/// @author  Dhraax
/// @brief   OnUsed of cnrArcaneTable. Opens the window.
///
///          Unlike cnr_device_ou, which waits for the SECOND fire to start a
///          conversation, this opens on the first: the window has to be in
///          front of the player while the container is loaded. The window
///          carries an id, so NUI treats it as a singleton and a second use
///          only refreshes it.
/// ----------------------------------------------------------------------------

#include "cnr_arc_nui"

void main()
{
    object oPC = GetLastUsedBy();
    if (!GetIsPC(oPC))
    {
        return;
    }
    CnrArcN_Open(oPC, OBJECT_SELF);
}
