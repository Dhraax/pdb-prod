//::///////////////////////////////////////////////
//:: TIRADOR DE LA ESPESURA: IMPACTO VERDADERO MEJORADO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Como impacto verdadero, pero en arcos y ballestas y dura el doble
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 27 de Abril de 2011
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"

void main()
{
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
*/

  if (!X2PreSpellCastCode())
  {
      // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
      return;
  }

  // End of Spell Cast Hook

  //Declare major variables
  object oPC = OBJECT_SELF;
  effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
  effect eAttack = EffectAttackIncrease(20);
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
  effect eLink = eAttack;
  eLink = EffectLinkEffects(eLink, eDur);

  // Solo se usa con un arco o ballesta equipada
  int iObjetoBase = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
  if(iObjetoBase != BASE_ITEM_LIGHTCROSSBOW &&
     iObjetoBase != BASE_ITEM_HEAVYCROSSBOW &&
     iObjetoBase != BASE_ITEM_SHORTBOW      &&
     iObjetoBase != BASE_ITEM_LONGBOW)
  {
      IncrementRemainingFeatUses(oPC, 1151);
      SendMessageToPC(oPC, "<cþ<<>Impacto verdadero mejorado sólo funciona si tienes equipado un arco o una ballesta.</c>");
      return;
  }

  //Fire spell cast at event for target
  SignalEvent(oPC, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
  //Apply VFX impact and bonus effects
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(1)+3);
}

