/// ----------------------------------------------------------------------------
/// @system  CNR Arcane
/// @file    cnr_ext_leave
/// @author  Dhraax
/// @brief   Dialogue action for the extraction machine: leave it alone.
///
///          Nothing is destroyed and nothing is handed over. The option exists
///          so the player can look at what the machine says and walk away, and
///          it carries a script for the same reason the shops' "me marcho"
///          does: leaving is a thing the system has to notice.
///
///          What it notices is that the conversation is over, which is when
///          the machine has to go deaf for a few seconds. See CnrExt_Seal.
/// ----------------------------------------------------------------------------

#include "cnr_i_extract"

void main()
{
    object oPC = GetPCSpeaker();
    object oMachine = OBJECT_SELF;

    if (!GetIsPC(oPC) || !GetIsObjectValid(oMachine))
    {
        return;
    }

    CnrExt_Seal(oPC, oMachine);
}
