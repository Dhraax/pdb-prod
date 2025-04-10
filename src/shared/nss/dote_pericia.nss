//::///////////////////////////////////////////////
//:: DOTE PERICIA EN COMBATE Y PERICIA EN COMBATE MEJORADA
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 30 de Mayo de 2011
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "inc_timelock"

void main()
{
  object oPC = OBJECT_SELF;
  int iConjuro = GetSpellId();

  // Ajustes
  if(iConjuro == 902 || iConjuro == 905)
  {
      if(GetHasFeat(1226, oPC)) SendMessageToPC(oPC, "<cÍþ>Escribe 'PC + un número entre 1 y 10' para establecer el bonificador / penalizador deseado en Pericia en combate, por ejemplo, 'PC 8' (sin comillas). Recuerda que este número nunca podrá ser mayor al de tu ataque base.</c>");
      else SendMessageToPC(oPC, "<cÍþ>Escribe 'PC + un número entre 1 y 5' para establecer el bonificador / penalizador deseado en Pericia en combate, por ejemplo, 'PC 3' (sin comillas). Recuerda que este número nunca podrá ser mayor al de tu ataque base.</c>");
      return;
  }
    // Cooldown check.
    if(GetIsTimelocked(oPC, "Pericia en Combate"))
    {
        TimelockErrorMessage(oPC, "Pericia en Combate");
        return;
    }
  // Desactivacion del modo
  if(GetHasSpellEffect(901) || GetHasSpellEffect(904))
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Pericia en combate desactivado *</c>", OBJECT_SELF, FALSE);
      RemoveEffectsFromSpell(oPC, 901);
      RemoveEffectsFromSpell(oPC, 904);
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
      FloatingTextStringOnCreature("<cþ<<>* En tu estado no puedes activar el Modo Pericia en combate *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // Si estas en furia barbara no puedes usar este modo
  if(GetHasFeatEffect(FEAT_BARBARIAN_RAGE, oPC))
  {
      FloatingTextStringOnCreature("<cþ<<>* Enfurecido no puedes activar el Modo Pericia en combate *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // Armas a distancia no (hachas arrojadizas, dardos, shurikens, arcos, ballestas, hondas)
  object oArmaEquipada = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
  int iTipoArmaEquipada = GetBaseItemType(oArmaEquipada);
  if(iTipoArmaEquipada == 31  || iTipoArmaEquipada == 59  || iTipoArmaEquipada == 63  ||
     iTipoArmaEquipada == 8   || iTipoArmaEquipada == 11  || iTipoArmaEquipada == 6   ||
     iTipoArmaEquipada == 7   || iTipoArmaEquipada == 61)
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Pericia en combate no activado [arma inválida] *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // AntiSPAM
  if(GetLocalInt(oPC, "SPAM_PERICIA"))
  {
      FloatingTextStringOnCreature("<cþ<<>* No puedes reactivar tan rápidamente el Modo Pericia en combate *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // INCOMPATIBILIDADES
  // 1. Combatir a la defensiva
  // 2. Defensa total
  // 3. Ataque poderoso
  if(GetHasSpellEffect(883))
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Combatir a la defensiva desactivado *</c>", OBJECT_SELF, FALSE);
      RemoveEffectsFromSpell(oPC, 883);
  }
  if(GetHasSpellEffect(884))
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Defensa total desactivado *</c>", OBJECT_SELF, FALSE);
      RemoveEffectsFromSpell(oPC, 884);
  }
  if(GetHasSpellEffect(898))
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Ataque poderoso desactivado *</c>", OBJECT_SELF, FALSE);
      RemoveEffectsFromSpell(oPC, 898);
  }

  int iAtaqueBase = GetBaseAttackBonus(oPC);

  // Obtenemos el numero guardado, sino hay, sera la mitad de tu ataque base
  // int iNumeroGuardado = GetLocalInt(oPC, "DOTE_PERICIA_AJUSTE");
  int iNumeroGuardado = ObtenerIntPersistente(oPC, "DOTE_PERICIA_AJUSTE");
  if(iNumeroGuardado == 0) iNumeroGuardado = iAtaqueBase / 2;

  if(iNumeroGuardado > 10) iNumeroGuardado = 10;
  else if(iNumeroGuardado < 1) iNumeroGuardado = 1;

  // Aplicacion
  effect eAtaque = EffectAttackDecrease(iNumeroGuardado);
  effect eCA = EffectACIncrease(iNumeroGuardado);
  effect ePenalizadorMovimiento = EffectMovementSpeedDecrease(50);
  effect ePenalizadorConjurar = EffectSpellFailure(100);
  effect eLink = EffectLinkEffects(eAtaque, eCA);
  eLink = EffectLinkEffects(eLink, ePenalizadorMovimiento);
  eLink = EffectLinkEffects(eLink, ePenalizadorConjurar);
  eLink = ExtraordinaryEffect(eLink);

  FloatingTextStringOnCreature("<c´þd>* Modo Pericia en combate ["+IntToString(iNumeroGuardado)+"] activado *</c>", oPC, FALSE);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
  SetTimelock(oPC, 6, "Pericia en Combate", 0, 0);
}
