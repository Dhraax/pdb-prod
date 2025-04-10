//::///////////////////////////////////////////////
//:: Darkvision
//:: NW_S0_DarkVis
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Applies the darkvision effect to the target for
    1 hour per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 13, 2001
//:://////////////////////////////////////////////
//Needed: New effect

#include "x2_inc_spellhook"
#include "pb_nivellanzador"
#include "inc_spells"

// void main()
// {
// DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
// /*
//   Spellcast Hook Code
//   Added 2003-06-23 by GeorgZ
//   If you want to make changes to all spells,
//   check x2_inc_spellhook.nss to find out more

// */

//     if (!X2PreSpellCastCode())
//     {
//     // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
//         return;
//     }

// // End of Spell Cast Hook


//     //Declare major variables
//     object oTarget = GetSpellTargetObject();
//     effect eVis = EffectVisualEffect(VFX_DUR_ULTRAVISION);
//     effect eVis2 = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
//     effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
//     effect eUltra = EffectUltravision();
//     effect eLink = EffectLinkEffects(eVis, eDur);
//     eLink = EffectLinkEffects(eLink, eVis2);
//     eLink = EffectLinkEffects(eLink, eUltra);

//     int nDuration = GetTotalCasterLevel(OBJECT_SELF);
//     int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
//     SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DARKVISION, FALSE));
//     //Enter Metamagic conditions
//     if (nMetaMagic == METAMAGIC_EXTEND)
//     {
//         nDuration = nDuration *2; //Duration is +100%
//     }
//     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
//     DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// }

void main()
{
    //if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    effect eEffect;
    int nSpell       = GetSpellId();
    int nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
    int nMetaMagic   = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    int nDuration    = nCasterLevel;

     if (!X2PreSpellCastCode())
     {
         return;
     }

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    //apply
    eEffect =
        EffectLinkEffects(
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_ULTRAVISION),
                EffectLinkEffects(
                    EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT),
                    EffectUltravision())));

    gsSPApplyEffect(
        oTarget,
        eEffect,
        nSpell,
        HoursToSeconds(nDuration));
}
