//::///////////////////////////////////////////////
//:: Associate: Heartbeat
//:: NW_CH_AC1.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Move towards master or wait for him
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 21, 2001
//:: Updated On: Jul 25, 2003 - Georg Zoeller
//:://////////////////////////////////////////////
#include "X0_INC_HENAI"
#include "hench_i0_generic"



void main()
{
//    Jug_Debug("*****" + GetName(OBJECT_SELF) + " heartbeat " + IntToString(GetCurrentAction()) + " busy " + IntToString(GetAssociateState(NW_ASC_IS_BUSY)));


    if (GetLocalInt(OBJECT_SELF, "bmc_active"))
            {
                return;
            }

    // If the henchman is in dying mode, make sure
    // they are non commandable. Sometimes they seem to
    // 'slip' out of this mode
    int bDying = GetIsHenchmanDying();

    if (bDying)
    {
        int bCommandable = GetCommandable();
        if (bCommandable == TRUE)
        {
            // lie down again
            ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT,
                                          1.0, 65.0);
           SetCommandable(FALSE);
        }
    }

    // If we're dying or busy, we return
    // (without sending the user-defined event)
    if(GetAssociateState(NW_ASC_IS_BUSY) || bDying)
    {
        return;
    }

    ExecuteScript("nw_ch_ac1", OBJECT_SELF);
}




