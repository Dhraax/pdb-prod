//::///////////////////////////////////////////////
//:: TIRADOR DE LA ESPESURA: APUNTAR +2
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    +2 al ataque durante 1 minuto
    hay que esperarse 5 min para volver a usarse
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 27 de Abril de 2011
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void ApuntarFinalizado()
{
  if(GetHasSpellEffect(871, OBJECT_SELF))
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Apuntar desactivado *</c>", OBJECT_SELF, FALSE);
  }
}

void main()
{
  object oPC = OBJECT_SELF;
  object oMod = GetModule();

  // Si ya tenemos el modo apuntar activado, lo desactivamos
  if(GetHasSpellEffect(871, OBJECT_SELF))
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Apuntar desactivado *</c>", OBJECT_SELF, FALSE);
      RemoveEffectsFromSpell(OBJECT_SELF, 871);
      return;
  }

  // Solo se usa con un arco o ballesta equipada
  int iObjetoBase = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
  if(iObjetoBase != BASE_ITEM_LIGHTCROSSBOW &&
     iObjetoBase != BASE_ITEM_HEAVYCROSSBOW &&
     iObjetoBase != BASE_ITEM_SHORTBOW      &&
     iObjetoBase != BASE_ITEM_LONGBOW)
  {
      SendMessageToPC(oPC, "<cþ<<>El Modo Apuntar sólo funciona si tienes equipado un arco o una ballesta.</c>");
      return;
  }

  // Solo se puede usar el modo apuntar cada 5 minutos
  if(GetLocalInt(oMod, "MODOAPUNTAR" + GetName(oPC, TRUE)) == TRUE)
  {
      SendMessageToPC(oPC, "<cþ<<>Sólo se puede usar el Modo Apuntar cada 5 minutos.</c>");
      return;
  }

  SetLocalInt(oMod, "MODOAPUNTAR" + GetName(oPC, TRUE), TRUE);
  DelayCommand(300.0, DeleteLocalInt(oMod, "MODOAPUNTAR" + GetName(oPC, TRUE)));

   // APLICAMOS LOS EFECTOS!
  FloatingTextStringOnCreature("<c´þd>* Modo Apuntar activado; Aguantas la respiración para apuntar a tu objetivo *</c>", OBJECT_SELF, FALSE);
  effect eAtaque2 = ExtraordinaryEffect(EffectAttackIncrease(2));
  effect eImmobilize = EffectCutsceneImmobilize();
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImmobilize, OBJECT_SELF, 6.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAtaque2, OBJECT_SELF, 12.0);

  DelayCommand(11.5, ApuntarFinalizado());
}

