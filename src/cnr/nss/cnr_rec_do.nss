/// ----------------------------------------------------------------------------
/// @system  CNR Recycling
/// @file    cnr_rec_do
/// @author  Dhraax
/// @brief   Confirms the recycler payout and seals the machine.
/// ----------------------------------------------------------------------------

#include "cnr_i_recycle"

void main()
{
    object oPC = GetPCSpeaker();
    if (!GetIsPC(oPC))
    {
        return;
    }
    CnrRec_Recycle(oPC, OBJECT_SELF);
    CnrRec_Seal(oPC, OBJECT_SELF);
}
