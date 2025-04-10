//::///////////////////////////////////////////////
//:: Darkness
//:: NW_S0_Darkness.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Oscuridad para el Asesino.
*/
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_spells"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
    //if (gsSPGetOverrideSpell()) return;
    location lTarget = GetSpellTargetLocation();
    int nDuration = 1 + GetLevelByClass(CLASS_TYPE_ASSASSIN, OBJECT_SELF);
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

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



