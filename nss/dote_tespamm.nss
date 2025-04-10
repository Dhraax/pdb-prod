//::///////////////////////////////////////////////
//:: TIRADOR DE LA ESPESURA: ARMA DE PROYECTIL MAYOR MAGICA
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Como arma magica mayor, pero en arcos y ballestas.
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
      Added 2003-07-07 by Georg Zoeller
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
  effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
  int nDuration = GetHitDice(OBJECT_SELF);

  //Limit nCasterLvl to 5, so it max out at +5 enhancement to the weapon.
  int nCasterLvl = nDuration / 3;
  if(nCasterLvl > 5) nCasterLvl = 5;

  // Solo se usa con un arco o ballesta equipada
  object oArma = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
  int iArmaObjetoBase = GetBaseItemType(oArma);
  if(iArmaObjetoBase != BASE_ITEM_LIGHTCROSSBOW &&
     iArmaObjetoBase != BASE_ITEM_HEAVYCROSSBOW &&
     iArmaObjetoBase != BASE_ITEM_SHORTBOW      &&
     iArmaObjetoBase != BASE_ITEM_LONGBOW)
  {
      IncrementRemainingFeatUses(oPC, 1148);
      SendMessageToPC(oPC, "Arma de proyectil mayor mágica sólo funciona si tienes equipado un arco o una ballesta.");
      return;
  }

  //Fire spell cast at event for target
  SignalEvent(oPC, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
  //Apply VFX impact and bonus effects
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oPC, HoursToSeconds(nDuration));
  IPSafeAddItemProperty(oArma, ItemPropertyEnhancementBonus(nCasterLvl), HoursToSeconds(nDuration), X2_IP_ADDPROP_POLICY_IGNORE_EXISTING ,TRUE,TRUE);
}
