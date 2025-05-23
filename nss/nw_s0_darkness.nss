//::///////////////////////////////////////////////
//:: Darkness
//:: NW_S0_Darkness.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_spells"

void main()
{

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //if (gsSPGetOverrideSpell()) return;
    location lTarget = GetSpellTargetLocation();
    int nDuration = GetTotalCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    //apply
    CreateNonStackingPersistentAoE(DURATION_TYPE_TEMPORARY, AOE_PER_DARKNESS, lTarget, RoundsToSeconds(nDuration));

    //trigger spell cast at event
    object oTarget = GetSpellTargetObject();
    if (GetIsObjectValid(oTarget))
    {
      object oCaster = OBJECT_SELF;
      SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DARKNESS, FALSE));
    }
}
