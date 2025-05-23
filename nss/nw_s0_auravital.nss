//::///////////////////////////////////////////////
//:: Aura of Vitality
//:: NW_S0_AuraVital
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All allies within the AOE gain +4 Str, Con, Dex
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "nostack_inc"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget;
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
    int nDuration = GetTotalCasterLevel(OBJECT_SELF);
    float fDelay;

    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration *= 2; //Duration is +100%
    }
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if(GetFactionEqual(oTarget) || GetIsReactionTypeFriendly(oTarget))
        {
            fDelay = GetRandomDelay(0.4, 1.1);
            //Signal the spell cast at event
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_AURA_OF_VITALITY, FALSE));
            //Apply effects and VFX to target
            DelayCommand(fDelay, DoNoStackAbilityBonus(OBJECT_SELF, oTarget, 4, ABILITY_STRENGTH, RoundsToSeconds(nDuration)));
            DelayCommand(fDelay, DoNoStackAbilityBonus(OBJECT_SELF, oTarget, 4, ABILITY_DEXTERITY, RoundsToSeconds(nDuration)));
            DelayCommand(fDelay, DoNoStackAbilityBonus(OBJECT_SELF, oTarget, 4, ABILITY_CONSTITUTION, RoundsToSeconds(nDuration)));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oTarget, RoundsToSeconds(nDuration)));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
        
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
