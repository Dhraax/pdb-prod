//::///////////////////////////////////////////////
//:: Associate: End of Combat End
//:: NW_CH_AC3
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calls the end of combat script every round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified On: Jan 16th, 2008
//:: Added Support for Mounted Combat Feat Support
//:://////////////////////////////////////////////
#include "hench_i0_ai"

void main()
{
//    Jug_Debug("*****" + GetName(OBJECT_SELF) + " end combat round action " + IntToString(GetCurrentAction()) + " busy " + IntToString(GetAssociateState(NW_ASC_IS_BUSY)));

    DeleteLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_RUN_STATE);


            // Don't do anything if we have have been recently commanded
            if (GetLocalInt(OBJECT_SELF, "bmc_active"))
            {
                // See if we have a valid creature to attack
                object oTarget = GetLocalObject(OBJECT_SELF, "bmc_attacktarget");
                if (GetIsObjectValid(oTarget) && GetIsEnemy(oTarget) && !GetIsDead(oTarget))
                {
                    DetermineCombatRound(oTarget);
                    return;
                }
                else
                {
                    DeleteLocalObject(OBJECT_SELF, "bmc_attacktarget");
                }

                oTarget = GetAttackTarget();
                if (GetIsObjectValid(oTarget) && GetIsEnemy(oTarget) && !GetIsDead(oTarget))
                {
                    DetermineCombatRound(oTarget);
                    return;
                }

                oTarget = GetAttemptedAttackTarget();
                if (GetIsObjectValid(oTarget) && GetIsEnemy(oTarget) && !GetIsDead(oTarget))
                {
                    DetermineCombatRound(oTarget);
                    return;
                }

                return;
            }


    if (!GetLocalInt(GetModule(),"X3_NO_MOUNTED_COMBAT_FEAT"))
    { // set variables on target for mounted combat
        DeleteLocalInt(OBJECT_SELF,"bX3_LAST_ATTACK_PHYSICAL");
        DeleteLocalInt(OBJECT_SELF,"nX3_HP_BEFORE");
        DeleteLocalInt(OBJECT_SELF,"bX3_ALREADY_MOUNTED_COMBAT");
    } // set variables on target for mounted combat

    if(!GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
    {
        HenchDetermineCombatRound();
    }
    if(GetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_END_COMBAT_ROUND));
    }



}
