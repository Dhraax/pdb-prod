/// ----------------------------------------------------------------------------
/// @system  CNR Harvesting
/// @file    cnr_skin_hit
/// @author  Dhraax
/// @brief Route attacks on the existing dead creature to skinning.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------
#include "cnr_i_skin"

void main()
{
    if (!GetIsDead(OBJECT_SELF))
    {
        string sPrevious = GetLocalString(OBJECT_SELF, CNR_SKIN_ATTACK_SCRIPT);
        if (sPrevious != "" && sPrevious != "cnr_skin_hit")
        {
            ExecuteScript(sPrevious, OBJECT_SELF);
        }
        return;
    }

    object oPC = GetLastAttacker();

    if (!GetIsPC(oPC) || GetIsDM(oPC))
    {
        return;
    }

    CnrSkin_Strike(oPC, OBJECT_SELF);
}
