/// ----------------------------------------------------------------------------
/// @system  CNR Arcane
/// @file    cnr_ext_break
/// @author  Dhraax
/// @brief   Dialogue action for the extraction machine: break everything.
///
///          The machine is read again here. Whatever the dialogue text said
///          when it opened does not count: between opening and choosing, the
///          player could have taken items out. Because a conversation closes
///          the container's inventory, nothing can change while this runs.
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

    CnrExt_BreakAll(oPC, oMachine);
    CnrExt_Seal(oPC, oMachine);
}
