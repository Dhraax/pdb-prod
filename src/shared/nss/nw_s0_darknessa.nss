//::///////////////////////////////////////////////
//:: Darkness: On Enter
//:: NW_S0_DarknessA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 28, 2002
//:://////////////////////////////////////////////
#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "inc_spells"

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    effect eEffectDarkness;
    effect eEffectConcealment;
    int nSpell     = GetSpellId();

    // Escape for DMs
    if(GetIsDM(oTarget) == TRUE && GetIsDMPossessed(oTarget) == FALSE)
    {
        return;
    }

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, oCaster, oTarget)) return;
    
    //raise event
    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpell, FALSE));

    //resistance check
    if (gsSPResistSpell(oCaster, oTarget, nSpell)) return;

    //apply
    eEffectDarkness =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE),
            EffectDarkness());
    eEffectConcealment =
    EffectLinkEffects(
        EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
        EffectConcealment(20));

    gsSPApplyEffect(oTarget, eEffectDarkness, nSpell, GS_SP_DURATION_PERMANENT);
    gsSPApplyEffect(oTarget, eEffectConcealment, nSpell, GS_SP_DURATION_PERMANENT);
}


