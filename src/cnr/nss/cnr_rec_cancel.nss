/// ----------------------------------------------------------------------------
/// @system  CNR Recycling
/// @file    cnr_rec_cancel
/// @author  Dhraax
/// @brief   Cancels recycling without changing the input.
/// ----------------------------------------------------------------------------

#include "cnr_i_recycle"

void main()
{
    object oPC = GetPCSpeaker();
    if (GetIsPC(oPC))
    {
        CnrRec_Seal(oPC, OBJECT_SELF);
    }
}
