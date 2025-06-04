//::///////////////////////////////////////////////
//:: True Seeing
//:: NW_S0_TrueSee.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The creature can seen all invisible or sanctuared,
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: [date]
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "pb_nivellanzador"
#include "inc_spells"
#include "nostack_inc"

void main()
{
    //Permitimos la creación de pergaminos.
    if (!X2PreSpellCastCode())
    {
        return;
    }

    //if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    // effect eEffect;
    int nSpell       = GetSpellId();
    int nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
    int nMetaMagic   = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    int nDuration    = nCasterLevel;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    // The Truesight spell now gives 1 round of True Seeing, and CL rounds of +10 Spot.
    // Divination spell foci increase the True Seeing rounds by +1 each for Spell Focus and Greater Spell Focus, and +2 for Epic Spell Focus.

    //effect eTS = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), EffectTrueSeeing());
    effect eSight = EffectSeeInvisible();
    effect eUltraVision = EffectUltravision();
    effect eSpot = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eImmunidadAsesinoFantasmal = EffectSpellImmunity(SPELL_PHANTASMAL_KILLER);
    effect eImmunidadNemesisInexorable = EffectSpellImmunity(SPELL_WEIRD);
    effect eAbsorb = EffectSpellLevelAbsorption(9, 0, SPELL_SCHOOL_ILLUSION);
    eSpot = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT), eSpot);

    int nTSDur = 0;
    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_DIVINATION)) nTSDur = 4;
    else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINATION)) nTSDur = 2;
    else if (GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION)) nTSDur = 1;

    //gsSPApplyEffect(oTarget, eTS, nSpell, TurnsToSeconds(nTSDur + nDuration));
    gsSPApplyEffect(oTarget, eSight, nSpell, TurnsToSeconds(nTSDur + nDuration));
    gsSPApplyEffect(oTarget, eUltraVision, nSpell, TurnsToSeconds(nTSDur + nDuration));
    gsSPApplyEffect(oTarget, eSpot, nSpell, TurnsToSeconds(nTSDur + nDuration));
    gsSPApplyEffect(oTarget, eImmunidadAsesinoFantasmal, nSpell, TurnsToSeconds(nTSDur + nDuration));
    gsSPApplyEffect(oTarget, eImmunidadNemesisInexorable, nSpell, TurnsToSeconds(nTSDur + nDuration));
    gsSPApplyEffect(oTarget, eAbsorb, nSpell, TurnsToSeconds(nTSDur + nDuration));

    DoNoStackSkillBonus(OBJECT_SELF, oTarget, 5, SKILL_SPOT, TurnsToSeconds(nTSDur + nDuration),GetSpellId());
}
