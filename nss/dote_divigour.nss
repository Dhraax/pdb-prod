//::///////////////////////////////////////////////
//:: Vigor Divino
//:://////////////////////////////////////////////
/*
    Gasta un uso diario de "expulsar a los muertos" para ganar 10ft extras de movimiento
    (lo que equivale a 33%) y un +2 temporal de constitucion durante un numero de minutos
    igual al modificador de carisma.
*/
//:://////////////////////////////////////////////
//:: Created By: Idelish y modificado por Monti
//:: Created On: Mar 20, 2010
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
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
  effect eMove = EffectMovementSpeedIncrease(33);
  effect eLink = EffectLinkEffects(eDur, eMove);

  //Declarando variable de disipacion
    string sVarName = GetName(OBJECT_SELF, TRUE);
    sVarName += IntToString(GetSpellId());
    int nValue = GetLevelByClass(41, OBJECT_SELF);  //Sumamos niveles de caballero protector.
    nValue += GetLevelByClass(32, OBJECT_SELF);     //Sumamos niveles de campeon divino.
    nValue += GetLevelByClass(2, OBJECT_SELF);      //Sumamos niveles de clerigo
    nValue += GetLevelByClass(6, OBJECT_SELF);      //Sumamos niveles de paladin
    nValue += GetLevelByClass(50, OBJECT_SELF);     //Sumamos niveles de soldado de la luz

  // * Do not allow this to stack
  RemoveEffectsFromSpell(oTarget, GetSpellId());

  //Fire cast spell at event for the specified target
  SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 856, FALSE));

  //Apply Link and VFX effects to the target
  DoNoStackAbilityBonus(OBJECT_SELF, oTarget, 2, ABILITY_CONSTITUTION, TurnsToSeconds(nCharismaBonus));
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nCharismaBonus));
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), oTarget);
  SetLocalInt(oTarget, sVarName, nValue);
}
