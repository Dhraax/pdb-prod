//::///////////////////////////////////////////////
//:: Default: End of Combat Round
//:: NW_C2_DEFAULT3
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calls the end of combat script every round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////

#include "hench_i0_ai"


void main()
{
//    Jug_Debug("*****" + GetName(OBJECT_SELF) + " end combat round action " + IntToString(GetCurrentAction()));

    if (!GetLocalInt(GetModule(),"X3_NO_MOUNTED_COMBAT_FEAT"))
    { // set variables on target for mounted combat
        DeleteLocalInt(OBJECT_SELF,"bX3_LAST_ATTACK_PHYSICAL");
        DeleteLocalInt(OBJECT_SELF,"nX3_HP_BEFORE");
        DeleteLocalInt(OBJECT_SELF,"bX3_ALREADY_MOUNTED_COMBAT");
        if (GetHasFeat(FEAT_MOUNTED_COMBAT,OBJECT_SELF))
        { // check for AC increase
            int nRoll=d20()+GetSkillRank(SKILL_RIDE);
            nRoll=nRoll-10;
            if (nRoll>4)
            { // ac increase
                nRoll=nRoll/5;
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectACIncrease(nRoll),OBJECT_SELF,8.5);
            } // ac increase
        } // check for AC increase
    } // set variables on target for mounted combat

    DeleteLocalInt(OBJECT_SELF, HENCH_AI_SCRIPT_RUN_STATE);

    if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
    {
        HenchDetermineSpecialBehavior();
    }
    else if(!GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
    {
        HenchDetermineCombatRound();
    }
    // special code for host tower level 4
    if(GetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT) && GetTag(OBJECT_SELF) != "2Q6_HelmHorror")
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_END_COMBAT_ROUND));
    }
}


