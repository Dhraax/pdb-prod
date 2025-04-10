//::///////////////////////////////////////////////
//:: GreaterWildShape III - Drider Darkness Ability
//:: x2_s2_driderdark
//:: Copyright (c) 2003Bioware Corp.
//:://////////////////////////////////////////////
/*

  Drider Darkness Ability for polymorph type
  drider

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: July, 07, 2003
//:://////////////////////////////////////////////

#include "x2_inc_shifter"
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_spells"

void main()
{

    //--------------------------------------------------------------------------
    // Enforce artifical use limit on that ability
    //--------------------------------------------------------------------------
    if (ShifterDecrementGWildShapeSpellUsesLeft() <1 )
    {
        FloatingTextStrRefOnCreature(83576, OBJECT_SELF);
        return;
    }
    //if (gsSPGetOverrideSpell()) return;
    location lTarget = GetSpellTargetLocation();
    int nDuration = 6;
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
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






