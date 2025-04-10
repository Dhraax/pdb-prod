//::///////////////////////////////////////////////
//:: DOTE CARGA
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Carga.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 15 de Junio de 2011
//:://////////////////////////////////////////////

#include "mti_libreria"
#include "x2_inc_itemprop"

void main()
{
  object oPC = OBJECT_SELF;
  object oObjetivo = GetSpellTargetObject();

  // Solo se carga a criaturas
  if(GetObjectType(oObjetivo) != OBJECT_TYPE_CREATURE)
  {
      FloatingTextStringOnCreature("<cþ<<>* Sólo puedes cargar a criaturas *</c>", OBJECT_SELF, FALSE);
      if(GetHasFeat(1414, oPC) )
      IncrementRemainingFeatUses(oPC, 1414);
      else if(GetHasFeat(1416, oPC) )
      IncrementRemainingFeatUses(oPC, 1416);
      else if(GetHasFeat(1417, oPC) )
      IncrementRemainingFeatUses(oPC, 1417);
      else if(GetHasFeat(1418, oPC) )
      IncrementRemainingFeatUses(oPC, 1418);
      return;
  }

  // No puedes cargar a uno mismo
  if(oObjetivo == oPC)
  {
      FloatingTextStringOnCreature("<cþ<<>* ¡No puedes cargar a ti mismo! *</c>", OBJECT_SELF, FALSE);
      if(GetHasFeat(1414, oPC) )
      IncrementRemainingFeatUses(oPC, 1414);
      else if(GetHasFeat(1416, oPC) )
      IncrementRemainingFeatUses(oPC, 1416);
      else if(GetHasFeat(1417, oPC) )
      IncrementRemainingFeatUses(oPC, 1417);
      else if(GetHasFeat(1418, oPC) )
      IncrementRemainingFeatUses(oPC, 1418);
      return;
  }

  // Comprobacion de distancia (10 metros)
  float fDistanciaCarga = GetDistanceBetween(oPC, oObjetivo);
  if(fDistanciaCarga < 10.0)
  {
      FloatingTextStringOnCreature("<cþ<<>* Necesitas estar a 10 metros o más para iniciar una carga *</c>", OBJECT_SELF, FALSE);
      if(GetHasFeat(1414, oPC) )
      IncrementRemainingFeatUses(oPC, 1414);
      else if(GetHasFeat(1416, oPC) )
      IncrementRemainingFeatUses(oPC, 1416);
      else if(GetHasFeat(1417, oPC) )
      IncrementRemainingFeatUses(oPC, 1417);
      else if(GetHasFeat(1418, oPC) )
      IncrementRemainingFeatUses(oPC, 1418);
      return;
  }

  // No armas a distancia
  object oArmaManoHabil = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
  if(GetWeaponRanged(oArmaManoHabil) == TRUE)
  {
      FloatingTextStringOnCreature("<cþ<<>* Sólo puedes carga con armas cuerpo a cuerpo *</c>", OBJECT_SELF, FALSE);
      if(GetHasFeat(1414, oPC) )
      IncrementRemainingFeatUses(oPC, 1414);
      else if(GetHasFeat(1416, oPC) )
      IncrementRemainingFeatUses(oPC, 1416);
      else if(GetHasFeat(1417, oPC) )
      IncrementRemainingFeatUses(oPC, 1417);
      else if(GetHasFeat(1418, oPC) )
      IncrementRemainingFeatUses(oPC, 1418);
      return;
  }

  // Con efectos dayninos no puedes usarla
  int iFalloDote = FALSE;
  if(GetIsResting(oPC) || GetLocalInt(oPC, "DERRIBADO") || GetLocalInt(oPC, "SLIDING")) iFalloDote = TRUE;

  effect eEfecto = GetFirstEffect(oPC);
  while(GetIsEffectValid(eEfecto))
  {
      if(GetEffectType(eEfecto) == EFFECT_TYPE_CHARMED ||           GetEffectType(eEfecto) == EFFECT_TYPE_CONFUSED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_CUTSCENE_PARALYZE || GetEffectType(eEfecto) == EFFECT_TYPE_CUTSCENEIMMOBILIZE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_DAZED ||             GetEffectType(eEfecto) == EFFECT_TYPE_DOMINATED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_ENTANGLE ||          GetEffectType(eEfecto) == EFFECT_TYPE_FRIGHTENED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_PARALYZE ||          GetEffectType(eEfecto) == EFFECT_TYPE_PETRIFY ||
         GetEffectType(eEfecto) == EFFECT_TYPE_SLEEP ||             GetEffectType(eEfecto) == EFFECT_TYPE_STUNNED) iFalloDote = TRUE;

      eEfecto = GetNextEffect(oPC);
  }

  if(iFalloDote == TRUE)
  {
      FloatingTextStringOnCreature("<cþ<<>* En tu estado no puedes activar la Carga *</c>", OBJECT_SELF, FALSE);
      if(GetHasFeat(1414, oPC) )
      IncrementRemainingFeatUses(oPC, 1414);
      else if(GetHasFeat(1416, oPC) )
      IncrementRemainingFeatUses(oPC, 1416);
      else if(GetHasFeat(1417, oPC) )
      IncrementRemainingFeatUses(oPC, 1417);
      else if(GetHasFeat(1418, oPC) )
      IncrementRemainingFeatUses(oPC, 1418);
      return;
  }

  // Anti-saturamiento de cargar
  if(GetLocalInt(oPC, "CARGA_NOSATURAR"))
  {
      FloatingTextStringOnCreature("<cþ<<>* No puedes iniciar una nueva carga tan rápidamente *</c>", OBJECT_SELF, FALSE);
      return;
  }

  //Solo sobre una Montura
  if(ObtenerIntPersistente(oPC, "CAB_MONTADO") == 0)
  {
      FloatingTextStringOnCreature("<cþ<<>* Solo puedes usar carga mortal sobre una montura *</c>", OBJECT_SELF, FALSE);
      if(GetHasFeat(1414, oPC) )
      IncrementRemainingFeatUses(oPC, 1414);
      else if(GetHasFeat(1416, oPC) )
      IncrementRemainingFeatUses(oPC, 1416);
      else if(GetHasFeat(1417, oPC) )
      IncrementRemainingFeatUses(oPC, 1417);
      else if(GetHasFeat(1418, oPC) )
      IncrementRemainingFeatUses(oPC, 1418);
      return;
  }

  SetLocalInt(oPC, "CARGA_NOSATURAR", TRUE);
  DelayCommand(10.0, DeleteLocalInt(oPC, "CARGA_NOSATURAR"));

  // CARGA
  object oTipodeObjeto =GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
  if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0 && GetBaseItemType(oTipodeObjeto) == 92 || GetBaseItemType(oTipodeObjeto) == BASE_ITEM_SHORTSPEAR || GetBaseItemType(oTipodeObjeto) == BASE_ITEM_LONGSWORD )
  {
      IPSafeAddItemProperty(oTipodeObjeto, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d12), fDistanciaCarga / 2.5, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
  }

  FloatingTextStringOnCreature("<c´þd>* Inicias un ataque de carga mortal *</c>", oPC);
  SendMessageToPC(oPC, "<c›þþ>" + GetName(oPC) + "</c> <cþ–2>inicia un ataque de carga mortal. Duración de los bonificadores: "+FloatToString(fDistanciaCarga / 2.5, 2,1)+" segundos.</c>");
  AssignCommand(oPC, ClearAllActions(TRUE));
  DelayCommand(0.1, AssignCommand(oPC, ActionAttack(oObjetivo)));
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedIncrease(200), oPC, fDistanciaCarga / 3.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(425), oPC, fDistanciaCarga / 3.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(2), oPC, fDistanciaCarga / 2.5);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACDecrease(2), oPC, fDistanciaCarga / 2.5);
  AssignCommand(oPC, DelayCommand(0.2, SetCommandable(FALSE)));
  AssignCommand(oPC, DelayCommand(fDistanciaCarga / 2.5, SetCommandable(TRUE)));
}

