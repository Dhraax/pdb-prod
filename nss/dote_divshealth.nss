//::///////////////////////////////////////////////
//:: Fortaleza Divina
//:://////////////////////////////////////////////
/*
    Gasta un uso diario de "expulsar a los muertos" para ganar un numero de puntos
    de golpe temporales igual a dos veces su modificador de carisma, durante un numero
    de minutos igual al modificador de carisma.
*/
//:://////////////////////////////////////////////
//:: Created By: Idelish y modificado por Monti
//:: Created On: Mar 21, 2010
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void main()
{
  // Hay que tener usos de Expulsar o reprender muertos vivientes
  if(!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
  {
      SendMessageToPC(OBJECT_SELF, "<cþ<<>" + GetStringByStrRef(40550) + "</c>");
      return;
  }

  // Se restan usos de Expulsar
  DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);

  //Declare major variables
  object oTarget = GetSpellTargetObject();
  int nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA);
  effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
  effect eHP = EffectTemporaryHitpoints(nCharismaBonus * 2);
  effect eLink = EffectLinkEffects(eHP, eDur);
  eLink = ExtraordinaryEffect(eLink);

  // * Do not allow this to stack
  RemoveEffectsFromSpell(oTarget, GetSpellId());

  //Fire cast spell at event for the specified target
  SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 844, FALSE));

  //Apply Link and VFX effects to the target
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nCharismaBonus));
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
