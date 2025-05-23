//::///////////////////////////////////////////////
//:: Shadow Shield
//:: NW_S0_ShadShld.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grants the caster +5 AC and 10 / +3 Damage
    Reduction and immunity to death effects
    and negative energy damage for 3 Turns per level.
    Makes the caster immune Necromancy Spells

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 22, 2001
//:://////////////////////////////////////////////


#include "x2_inc_spellhook"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ILLUSION);
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
    object oTarget = GetSpellTargetObject();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    //Do metamagic extend check
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration *= 2;  //Duration is +100%
    }
    effect eStone = EffectDamageReduction(10, DAMAGE_POWER_PLUS_THREE);
    effect eAC = EffectACIncrease(5, AC_NATURAL_BONUS);
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH_WARD);
    effect eShadow = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
    effect eSpell = EffectSpellLevelAbsorption(9, 0, SPELL_SCHOOL_NECROMANCY);
    effect eImmDeath = EffectImmunity(IMMUNITY_TYPE_DEATH);
    effect eImmNeg = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 100);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    //Link major effects
    effect eLink = EffectLinkEffects(eStone, eAC);
    eLink = EffectLinkEffects(eLink, eVis);
    eLink = EffectLinkEffects(eLink, eShadow);
    eLink = EffectLinkEffects(eLink, eImmDeath);
    eLink = EffectLinkEffects(eLink, eImmNeg);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eSpell);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SHADOW_SHIELD, FALSE));
    //Apply linked effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, (TurnsToSeconds(nDuration)/2));
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

