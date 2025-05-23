//::///////////////////////////////////////////////
//:: Mind Blank
//:: NW_S0_MindBlk.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All allies are granted immunity to mental effects
    in the AOE.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);
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


    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());

    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
        {
            effect eImm1 = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
            effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
            effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            effect eLink = EffectLinkEffects(eImm1, eVis);
                   eLink = EffectLinkEffects(eLink, eDur);
            effect eSearch = GetFirstEffect(oTarget);
               int bValid;
               int nDuration = GetTotalCasterLevel(OBJECT_SELF);
               int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
           //Enter Metamagic conditions
           if (nMetaMagic == METAMAGIC_EXTEND)
           {
              nDuration = nDuration *2; //Duration is +100%
           }

           //Fire cast spell at event for the specified target
           SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MIND_BLANK, FALSE));
           //Search through effects
           while(GetIsEffectValid(eSearch))
           {
             bValid = FALSE;
             //Check to see if the effect matches a particular type defined below
             if (GetEffectType(eSearch) == EFFECT_TYPE_DAZED)
             {
               bValid = TRUE;
             }
             else if(GetEffectType(eSearch) == EFFECT_TYPE_CHARMED)
             {
               bValid = TRUE;
             }
             else if(GetEffectType(eSearch) == EFFECT_TYPE_SLEEP)
             {
               bValid = TRUE;
             }
             else if(GetEffectType(eSearch) == EFFECT_TYPE_CONFUSED)
             {
               bValid = TRUE;
             }
             else if(GetEffectType(eSearch) == EFFECT_TYPE_STUNNED)
             {
               bValid = TRUE;
             }
             else if(GetEffectType(eSearch) == EFFECT_TYPE_DOMINATED)
             {
               bValid = TRUE;
             }
             // * Additional March 2003
             // * Remove any feeblemind originating effects
             else if (GetEffectSpellId(eSearch) == SPELL_FEEBLEMIND)
             {
               bValid = TRUE;
             }
             else if (GetEffectSpellId(eSearch) == SPELL_BANE)
             {
               bValid = TRUE;
             }

           //Apply damage and remove effect if the effect is a match
               if (bValid == TRUE)
              {
               RemoveEffect(oTarget, eSearch);
              }
              eSearch = GetNextEffect(oTarget);
           }

           //After effects are removed we apply the immunity to mind spells to the target
           DelayCommand (GetRandomDelay(), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration)));
           //spellApplyMindBlank(oTarget, GetSpellId(), GetRandomDelay());
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());
       
    }
	 DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
