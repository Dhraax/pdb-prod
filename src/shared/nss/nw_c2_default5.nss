//::///////////////////////////////////////////////
//:: Default On Attacked
//:: NW_C2_DEFAULT5
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If already fighting then ignore, else determine
    combat round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////

#include "hench_i0_ai"
#include "nw_i0_2q4luskan"
#include "mti_libreria"


void main()
{
    if (!GetLocalInt(GetModule(),"X3_NO_MOUNTED_COMBAT_FEAT"))
    { // set variables on target for mounted combat
        SetLocalInt(OBJECT_SELF,"bX3_LAST_ATTACK_PHYSICAL",TRUE);
        SetLocalInt(OBJECT_SELF,"nX3_HP_BEFORE",GetCurrentHitPoints(OBJECT_SELF));
    } // set variables on target for mounted combat

    if(GetFleeToExit())
    {
        ActivateFleeToExit();
    }
    else if (GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
    {
        // We give an attacker one warning before we attack
        // This is not fully implemented yet
        SetSpawnInCondition(NW_FLAG_SET_WARNINGS, FALSE);

        //Put a check in to see if this attacker was the last attacker
        //Possibly change the GetNPCWarning function to make the check
    }
    else if(!GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
    {
        object oAttacker = GetLastAttacker();

        if (!GetIsObjectValid(oAttacker))
        {
            // Don't do anything, invalid attacker

        }
        else if (!GetIsFighting(OBJECT_SELF))
        {
            if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
            {
                if(GetArea(GetLastAttacker()) == GetArea(OBJECT_SELF))
                {
                    CheckRemoveStealth();
                }
                SetSummonHelpIfAttacked();
                HenchDetermineSpecialBehavior(GetLastAttacker());
            }
            else if(GetArea(GetLastAttacker()) == GetArea(OBJECT_SELF))
            {
                CheckRemoveStealth();
                SetSummonHelpIfAttacked();
                HenchDetermineCombatRound(GetLastAttacker());
            }
        }
    }
    if(GetSpawnInCondition(NW_FLAG_ATTACK_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_ATTACKED));
    }


    // El desollado vivia aqui, colgado de OnAttacked, y repartia pepitas
    // de mineria con mensajes de piel. Lo sustituye el cadaver del CNR:
    // cnr_i_skin, desde el OnDeath de la criatura.

}
