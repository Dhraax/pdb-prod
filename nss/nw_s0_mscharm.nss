//::///////////////////////////////////////////////
//:: [Mass Charm]
//:: [NW_S0_MsCharm.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster attempts to charm a group of individuals
    who's HD can be no more than his level combined.
    The spell starts checking the area and those that
    fail a will save are charmed.  The affected persons
    are Charmed for 1 round per 2 caster levels.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 29, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 22, 2001

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"
#include "lib_race"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    object oTarget;
    effect eCharm = EffectCharmed();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eMind, eCharm);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_CHARM);
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    int nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
    int nDuration = nCasterLevel/2;
    int nHD = nCasterLevel;
    int nCnt = 0;
    float fDelay;
    int nAmount = nHD * 2;
    //Check for metamagic extend

    // MONTI: x10 LA DURACION
    nDuration = nDuration * 10;

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nCasterLevel;
    }

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    while (GetIsObjectValid(oTarget) && nAmount > 0)
    {
        if ((GetHasFeat(FEAT_MASTERY_SHAPES, OBJECT_SELF)) && (GetLocalInt(OBJECT_SELF, "archmage_mastery_shaping") == 1) && (!GetIsReactionTypeHostile(oTarget, OBJECT_SELF) || oTarget == OBJECT_SELF || GetMaster(oTarget) == OBJECT_SELF))
         {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE), oTarget);
        }
    else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            fDelay = GetRandomDelay();
            //Check that the target is humanoid or animal
            if (PB_Race_GetIsHumanoid(GetRacialType(oTarget)))
            {
                //SpeakString(IntToString(nAmount) + " and HD of " + IntToString(GetHitDice(oTarget)));
                if(nAmount > GetHitDice(oTarget))
                {
                    //Fire cast spell at event for the specified target
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_CHARM, FALSE));
                    //Make an SR check
                    if (!MyResistSpell(OBJECT_SELF, oTarget))
                    {
                        //Make a Will save to negate
                        if (!MySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_MIND_SPELLS))
                        {
                            //Apply the linked effects and the VFX impact
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        }
                    }
                    //Add the creatures HD to the count of affected creatures
                    //nCnt = nCnt + GetHitDice(oTarget);
                    nAmount = nAmount - GetHitDice(oTarget);
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());

    }
      DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
