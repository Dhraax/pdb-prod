//::///////////////////////////////////////////////
//:: Project Q Combat function Library
//:: q_inc_combat.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Culled from NwnE

    Miscellaneous combat functions.
*/
//:://////////////////////////////////////////////
//:: Created By: Paul Ste. Marie
//:: Created On: January 22, 2009
//:://////////////////////////////////////////////

#include "q_inc_itemprop"

//------------------------------------------------------------------------------
// FUNCTION DECLARATIONS
//------------------------------------------------------------------------------

// * Make the caller attack object oTarget.
void AttackTarget(object oTarget);

// * Get the nNth object perceived by the caller.
object GetNextTarget(int nNth);

// * Performs a constrict attack on object oTarget.
void ConstrictTarget(object oAttacker, object oTarget);

// * Performs a grapple attack on object oTarget.
void GrappleTarget(object oAttacker, object oTarget);


//------------------------------------------------------------------------------
// FUNCTION IMPLEMENTATION
//------------------------------------------------------------------------------

void AttackTarget(object oTarget)
{
    ClearAllActions();
    SetIsTemporaryEnemy(oTarget, OBJECT_SELF, TRUE, 60.0);
    ActionDoCommand(ActionAttack(oTarget));
}


object GetNextTarget(int nNth)
{
    return GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, OBJECT_SELF, nNth);
}

void ConstrictTarget(object oAttacker, object oTarget)
{
    int nAtt  = GetBaseAttackBonus(oAttacker);
    int nStr  = GetAbilityModifier(ABILITY_STRENGTH, oAttacker);
    int nSize = GetCreatureSize(oAttacker);
    int nMod, nRoll, nCheck, nAC;

    switch (nSize)
    {
        case CREATURE_SIZE_TINY:   nMod = -8;  break;
        case CREATURE_SIZE_SMALL:  nMod = -4;  break;
        case CREATURE_SIZE_MEDIUM: nMod = 0;   break;
        case CREATURE_SIZE_LARGE:  nMod = 4;   break;
        case CREATURE_SIZE_HUGE:   nMod = 8;   break;
    }

    nRoll = d20(1);
    nCheck = (nRoll) + (nAtt) + (nStr) + (nMod);
    nAC = GetAC(oTarget);

    //Grapple Check
    if (nRoll >= 20 || (nRoll > 1 && nCheck > nAC))
    {
        FloatingTextStringOnCreature("Grapple succeeded!", oTarget);

        effect eParal = EffectParalyze();
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
        effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
        effect eLink = EffectLinkEffects(eDur2, eDur);
        eLink = EffectLinkEffects(eLink, eParal);
        eLink = EffectLinkEffects(eLink, eDur3);

        //Apply the paralyze effect and the VFX impact
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));

        int nDam, nDam2;

        //Set damage based on attacker species and size
        switch (nSize)
        {
            case CREATURE_SIZE_LARGE:
            case CREATURE_SIZE_HUGE:
                if (GetTag(GetSpellCastItem()) == "PUDDINGSLAM")
                {
                    nDam = d6(2);
                    nDam2 = d6(2);
                }
                else if (GetTag(GetSpellCastItem()) == "OCHREJELLYSLAM")
                {
                    nDam = d4(2);
                    nDam2 = d4(1);
                }
            break;

            case CREATURE_SIZE_MEDIUM:
                if (GetTag(GetSpellCastItem()) == "PUDDINGSLAM")
                {
                    nDam = d10(1);
                    nDam2 = d10(1);
                }
                else if (GetTag(GetSpellCastItem()) == "OCHREJELLYSLAM")
                {
                    nDam2 = d6(1);
                    nDam2 = 2;
                }
            break;

            case CREATURE_SIZE_SMALL:
            case CREATURE_SIZE_TINY:
                if (GetTag(GetSpellCastItem()) == "PUDDINGSLAM")
                {
                    nDam = d6(1);
                    nDam2 = d6(1);
                }
                else if (GetTag(GetSpellCastItem()) == "OCHREJELLYSLAM")
                {
                    nDam = d4(1);
                    nDam2 = 1;
                }
            break;
        }
        nDam = nDam + GetAbilityModifier(ABILITY_STRENGTH, oAttacker);

        if (GetLocalInt(oTarget, "Grappled") == 1) //Make sure double damage does not occur
        {
            if (nDam > 0)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING), oTarget);
            }
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ACID_S), oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam2, DAMAGE_TYPE_ACID), oTarget);
        }
        SetLocalInt(oTarget, "Grappled", 1);
        DelayCommand(6.0f, ConstrictTarget(oAttacker, oTarget));
    }
    else
    {
        FloatingTextStringOnCreature("Grapple failed!", oTarget);
        DeleteLocalInt(oTarget, "Grappled");
    }
}

void GrappleTarget(object oAttacker, object oTarget)
{
    int nAtt  = GetBaseAttackBonus(oAttacker);
    int nStr  = GetAbilityModifier(ABILITY_STRENGTH, oAttacker);
    int nSize = GetCreatureSize(oAttacker);
    int nMod, nRoll, nCheck, nAC;

    switch (nSize)
    {
        case CREATURE_SIZE_TINY:   nMod = -8; break;
        case CREATURE_SIZE_SMALL:  nMod = -4; break;
        case CREATURE_SIZE_MEDIUM: nMod = 0; break;
        case CREATURE_SIZE_LARGE:  nMod = 4; break;
        case CREATURE_SIZE_HUGE:   nMod = 8; break;
    }

    nRoll = d20(1);
    nCheck = (nRoll) + (nAtt) + (nStr) + (nMod);
    nAC = GetAC(oTarget);

    //Grapple Check
    if (nRoll >= 20 || (nRoll > 1 && nCheck > nAC))
    {
        FloatingTextStringOnCreature("Grapple succeeded!", oTarget);

        effect eParal = EffectParalyze();
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
        effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
        effect eLink = EffectLinkEffects(eDur2, eDur);
        eLink = EffectLinkEffects(eLink, eParal);
        eLink = EffectLinkEffects(eLink, eDur3);

        //Apply the paralyze effect and the VFX impact
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));

        int nDam;

        if (GetLocalInt(oTarget, "Grappled") == 1) //Make sure double damage does not occur
        {
            //Set damage based on attacker size
            switch (nSize)
            {
                case CREATURE_SIZE_TINY:   nDam = 1; break;
                case CREATURE_SIZE_SMALL:  nDam = d2(1); break;
                case CREATURE_SIZE_MEDIUM: nDam = d3(1); break;
                case CREATURE_SIZE_LARGE:  nDam = d4(1); break;
                case CREATURE_SIZE_HUGE:   nDam = d6(1); break;
            }
            nDam = nDam + GetAbilityModifier(ABILITY_STRENGTH, oAttacker);

            if (nDam > 0)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING), oTarget);
            }
        }
        DelayCommand(6.0f, GrappleTarget(oAttacker, oTarget));
    }
    else
    {
        FloatingTextStringOnCreature("Grapple failed!", oTarget);
        DeleteLocalInt(oTarget, "Grappled");
    }
}

