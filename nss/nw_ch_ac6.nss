//::///////////////////////////////////////////////
//:: Associate: On Damaged
//:: NW_CH_AC6
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If already fighting then ignore, else determine
    combat round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 19, 2001
//:://////////////////////////////////////////////

#include "hench_i0_ai"
#include "x3_inc_horse"


void main()
{
    object oAttacker = GetLastDamager();
    object oTarget = GetAttackTarget();
    object oDamager = oAttacker;
    object oMe=OBJECT_SELF;
    int nHPBefore;

     // Don't do anything if we have have been recently commanded
            if (GetLocalInt(OBJECT_SELF, "bmc_active"))
            {
                return;
            }
    if (!GetLocalInt(GetModule(),"X3_NO_MOUNTED_COMBAT_FEAT"))
    if (GetHasFeat(FEAT_MOUNTED_COMBAT)&&HorseGetIsMounted(OBJECT_SELF))
    { // see if can negate some damage
        if (GetLocalInt(OBJECT_SELF,"bX3_LAST_ATTACK_PHYSICAL"))
        { // last attack was physical
            nHPBefore=GetLocalInt(OBJECT_SELF,"nX3_HP_BEFORE");
            if (!GetLocalInt(OBJECT_SELF,"bX3_ALREADY_MOUNTED_COMBAT"))
            { // haven't already had a chance to use this for the round
                SetLocalInt(OBJECT_SELF,"bX3_ALREADY_MOUNTED_COMBAT",TRUE);
                int nAttackRoll=GetBaseAttackBonus(oDamager)+d20();
                int nRideCheck=GetSkillRank(SKILL_RIDE,OBJECT_SELF)+d20();
                if (nRideCheck>=nAttackRoll&&!GetIsDead(OBJECT_SELF))
                { // averted attack
                    if (GetIsPC(oDamager)) SendMessageToPC(oDamager,GetName(OBJECT_SELF)+GetStringByStrRef(111991));
                    //if (GetIsPC(OBJECT_SELF)) SendMessageToPCByStrRef(OBJECT_SELF,111992);
                    if (GetCurrentHitPoints(OBJECT_SELF)<nHPBefore)
                    { // heal
                        effect eHeal=EffectHeal(nHPBefore-GetCurrentHitPoints(OBJECT_SELF));
                        AssignCommand(GetModule(),ApplyEffectToObject(DURATION_TYPE_INSTANT,eHeal,oMe));
                    } // heal
                } // averted attack
            } // haven't already had a chance to use this for the round
        } // last attack was physical
    } // see if can negate some damage

    if(!GetAssociateState(NW_ASC_IS_BUSY))
    {
        // Auldar: Make a check for taunting before running Ondamaged.
        if(!GetAssociateState(NW_ASC_MODE_STAND_GROUND) && (GetCurrentAction() != ACTION_FOLLOW)
            && (GetCurrentAction() != ACTION_TAUNT))
        {
            if ((GetLocalInt(OBJECT_SELF, HENCH_HEAL_SELF_STATE) == HENCH_HEAL_SELF_WAIT) &&
                (GetPercentageHPLoss(OBJECT_SELF) < 30))
            {
                // force heal
                HenchDetermineCombatRound(OBJECT_INVALID, TRUE);
            }
            else
            {
                // Auldar: Use combat checks from OnPerceive.
                if(!GetIsObjectValid(GetAttemptedAttackTarget()) &&
                   !GetIsObjectValid(GetAttackTarget()) &&
                   !GetIsObjectValid(GetAttemptedSpellTarget()))
                {
                    if(GetIsObjectValid(GetLastHostileActor()))
                    {
                        if(GetAssociateState(NW_ASC_MODE_DEFEND_MASTER))
                        {
                            if(!GetIsObjectValid(GetLastHostileActor(GetRealMaster())))
                            {
                                HenchDetermineCombatRound();
                            }
                        }
                        else
                        {
                            HenchDetermineCombatRound(oAttacker);
                        }
                    }
                }
            }
        }
    }
    if(GetSpawnInCondition(NW_FLAG_DAMAGED_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_DAMAGED));
    }
}
