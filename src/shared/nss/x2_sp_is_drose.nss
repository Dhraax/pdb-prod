//::///////////////////////////////////////////////
//:: Name x2_sp_is_drose
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Ioun Stone Power: Dusty Rose
    Gives the user 1 hours worth of +1 AC bonus,
    Deflection
    Cancels any other Ioun stone powers in effect
    on the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 13/02
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void main()
{
  RemoveEffectsFromSpell(OBJECT_SELF, 554); // No apilar

  effect eVFX = EffectVisualEffect(1544);
  effect eBonus = EffectACIncrease(1);
  effect eLink = EffectLinkEffects(eVFX, eBonus);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, 3600.0);
}
