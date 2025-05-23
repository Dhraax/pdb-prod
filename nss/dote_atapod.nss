//::///////////////////////////////////////////////
//:: DOTE ATAQUE PODEROSO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Dote Ataque poderoso.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 1 de Junio de 2011
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "mti_libreria"
#include "inc_timelock"

void main()
{
  object oPC = OBJECT_SELF;
  int iConjuro = GetSpellId();

  // Ajustes
  if(iConjuro == 899)
  {
      AssignCommand(oPC, ClearAllActions(TRUE));
      SendMessageToPC(oPC, "<cÍþ>Escribe 'AP + un número entre 1 y 10' para establecer el bonificador / penalizador deseado en Ataque poderoso, por ejemplo, 'AP 7' (sin comillas). Recuerda que este número nunca podrá ser mayor al de tu ataque base.</c>");
      return;
  }

    // Cooldown check.
    if(GetIsTimelocked(oPC, "Ataque Poderoso"))
    {
        TimelockErrorMessage(oPC, "Ataque Poderoso");
        return;
    }
    
  // Desactivacion del modo
  if(GetHasSpellEffect(898))
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Ataque poderoso desactivado *</c>", OBJECT_SELF, FALSE);
      RemoveEffectsFromSpell(oPC, 898);
      DeleteLocalInt(oPC, "DANYO_AP");
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
      FloatingTextStringOnCreature("<cþ<<>* En tu estado no puedes activar el Modo Ataque Poderoso *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // No puedes activar el modo con un arma ligera equipada o armas a distancia
  object oArmaEquipada = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
  int iTipoArmaEquipada = GetBaseItemType(oArmaEquipada);
  int iTamanyoArmaEquipada = StringToInt(Get2DAString("baseitems", "WeaponSize", iTipoArmaEquipada)); // 1 = tiny; 2 = small; 3 = medium; 4 = large.
  int iTamanyoJugador = GetCreatureSize(oPC);  // 1 = tiny; 2 = small; 3 = medium; 4 = large.

  if(oArmaEquipada != OBJECT_INVALID)
  {
      if((iTamanyoJugador == 4 && iTamanyoArmaEquipada <= 3) ||
         (iTamanyoJugador == 3 && iTamanyoArmaEquipada <= 2) ||
         (iTamanyoJugador == 2 && iTamanyoArmaEquipada <= 1) ||
          GetWeaponRanged(oArmaEquipada))
      {
          FloatingTextStringOnCreature("<cþ<<>* Modo Ataque poderoso no activado [arma inválida, ligera o a distancia] *</c>", OBJECT_SELF, FALSE);
          return;
      }
  }

  // INCOMPATIBILIDADES
  // 1. Pericia en combate
  if(GetHasSpellEffect(901) || GetHasSpellEffect(904))
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Pericia en combate desactivado *</c>", OBJECT_SELF, FALSE);
      RemoveEffectsFromSpell(oPC, 901);
      RemoveEffectsFromSpell(oPC, 904);
  }

  int iAtaqueBase = GetBaseAttackBonus(oPC);
  effect eAtaque, eLink;

  // PENALIZADOR DE ATAQUE
  // Primero obtenemos el numero guardado, sino hay, sera la mitad de su ataque base
  int iAtaque = ObtenerIntPersistente(oPC, "DOTE_AP_AJUSTE");
  if(iAtaque == 0) iAtaque = iAtaqueBase / 2;

  if(iAtaque > 10) iAtaque = 10;
  else if(iAtaque < 1) iAtaque = 1;

  // BONIFICADOR DANYO
  // (Si es un arma grande es el doble de danyo)
  int iDanyo = iAtaque;
  int AtaqueMejorado = (iDanyo*25/100); // 50% mas de danyo
  int AtaqueSupremo = (iDanyo*50/100); // 100% mas de danyo

  //BONO ATAQUE SUPREMO Y MEJORADO BERSEKER FRENETICO
  if(GetHasFeat(1455, oPC)) iDanyo = iDanyo + AtaqueSupremo;
  else if(GetHasFeat(1454, oPC)) iDanyo = iDanyo + AtaqueMejorado;

  if(oArmaEquipada != OBJECT_INVALID)
  {
      if((iTamanyoJugador == 1 && iTamanyoArmaEquipada >= 2) ||
         (iTamanyoJugador == 2 && iTamanyoArmaEquipada >= 3) ||
         (iTamanyoJugador == 3 && iTamanyoArmaEquipada >= 4) &&
          iTipoArmaEquipada != 324 && iTipoArmaEquipada != 321 &&
          iTipoArmaEquipada != 33  && iTipoArmaEquipada != 32  &&
          iTipoArmaEquipada != 12) { iDanyo = iDanyo * 2; }
  }

  if(iDanyo < 1) iDanyo = 1;

  // APLICACION DE BONUS / MALUS
  eAtaque = EffectAttackDecrease(iAtaque);
  eLink = ExtraordinaryEffect(eAtaque);
  FloatingTextStringOnCreature("<c´þd>* Modo Ataque poderoso ["+IntToString(iAtaque)+"] activado *</c>", oPC, FALSE);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
  SetTimelock(oPC, 6, "Ataque poderoso", 0, 0);
  SetLocalInt(oPC, "DANYO_AP", iDanyo);
  SetLocalInt(oPC, "SPAM_ATAPOD", SQLite_GetTimeStamp());
  DelayCommand(6.0, DeleteLocalInt(oPC, "SPAM_ATAPOD"));
}


