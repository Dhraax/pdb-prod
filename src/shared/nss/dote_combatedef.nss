//::///////////////////////////////////////////////
//:: DOTE COMBATIR A LA DEFENSIVA
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Combatir a la defensiva.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 25 de Mayo de 2011
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void main()
{
  object oPC = OBJECT_SELF;

  // Desactivacion del modo
  if(GetHasSpellEffect(883))
  {
      if(GetLocalInt(oPC, "SPAM_COMDEF"))
      {
          FloatingTextStringOnCreature("<cþ<<>* No puedes cancelar tan rápidamente el Modo Combatir a la defensiva *</c>", OBJECT_SELF, FALSE);
          return;
      }

      FloatingTextStringOnCreature("<cþ<<>* Modo Combatir a la defensiva desactivado *</c>", OBJECT_SELF, FALSE);
      RemoveEffectsFromSpell(oPC, 883);
      SetLocalInt(oPC, "SPAM_COMDEF", TRUE);
      DelayCommand(6.0, DeleteLocalInt(oPC, "SPAM_COMDEF"));
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
      FloatingTextStringOnCreature("<cþ<<>* En tu estado no puedes activar el Modo Combatir a la Defensiva *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // AntiSPAM
  if(GetLocalInt(oPC, "SPAM_COMDEF"))
  {
      FloatingTextStringOnCreature("<cþ<<>* No puedes reactivar tan rápidamente el Modo Combatir a la Defensiva *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // INCOMPATIBILIDADES
  // 1. Defensa total
  if(GetHasSpellEffect(884))
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Defensa total desactivado *</c>", OBJECT_SELF, FALSE);
      RemoveEffectsFromSpell(oPC, 884);
  }

  // Aplicacion de efectos
  effect eAttack = EffectAttackDecrease(4);
  effect eAC = EffectACIncrease(2);
  effect eLink = ExtraordinaryEffect(EffectLinkEffects(eAttack, eAC));
  FloatingTextStringOnCreature("<c´þd>* Modo Combatir a la defensiva activado *</c>", oPC, FALSE);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);

  SetLocalInt(oPC, "SPAM_COMDEF", TRUE);
  DelayCommand(6.0, DeleteLocalInt(oPC, "SPAM_COMDEF"));
}
