//::///////////////////////////////////////////////
//:: Venganza divina
//:://////////////////////////////////////////////
/*
    Con cada uso gastado de expulsar muertos el personaje recibe
    weapon damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Idelish y modificado por Monti
//:: Created On: Feb 25, 2010
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
  object oLAN = GetSpellTargetObject();
  int nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA);
  float fDuracion = RoundsToSeconds(nCharismaBonus);
  object oBra = GetItemInSlot(INVENTORY_SLOT_ARMS, oLAN);
  object oArmaIzq = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oLAN);
  object oArmaDch = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oLAN);
  object oBul = GetItemInSlot(INVENTORY_SLOT_BULLETS, oLAN);
  object oArr = GetItemInSlot(INVENTORY_SLOT_ARROWS, oLAN);
  object oBol = GetItemInSlot(INVENTORY_SLOT_BOLTS, oLAN);
  itemproperty ipAdd = ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_POSITIVE, IP_CONST_DAMAGEBONUS_2d6);

  // * Do not allow this to stack
  RemoveEffectsFromSpell(oLAN, GetSpellId());

  //Apply Link and VFX effects to the target
  ApplyEffectToObject(DURATION_TYPE_INSTANT,  EffectVisualEffect(VFX_IMP_SUPER_HEROISM), OBJECT_SELF);
  IPSafeAddItemProperty(oArmaIzq, ipAdd, fDuracion);
  IPSafeAddItemProperty(oArmaDch, ipAdd, fDuracion);
  IPSafeAddItemProperty(oBra, ipAdd, fDuracion);
  IPSafeAddItemProperty(oBul, ipAdd, fDuracion);
  IPSafeAddItemProperty(oArr, ipAdd, fDuracion);
  IPSafeAddItemProperty(oBol, ipAdd, fDuracion);

  //Fire cast spell at event for the specified target
  SignalEvent(oLAN, EventSpellCastAt(OBJECT_SELF, 846, FALSE));
}
