//::///////////////////////////////////////////////
//:: Divine Strength
//:: NW_S2_DivStr
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Clerigo Fuerza - Como impacto verdadero
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 4, 2001
//:://////////////////////////////////////////////

void main()
{
  //Declare major variables
  object oPC = OBJECT_SELF;
  effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
  effect eAttack = EffectAttackIncrease(20);
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
  effect eLink = eAttack;
  eLink = EffectLinkEffects(eLink, eDur);

  //Fire cast spell at event for the specified target
  SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DIVINE_STRENGTH, FALSE));
  //Apply VFX impact and bonus effects
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 12.0);
}
