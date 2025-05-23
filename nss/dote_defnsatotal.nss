//::///////////////////////////////////////////////
//:: DOTE DEFENSA TOTAL
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Modo Defensa total.
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
  if(GetHasSpellEffect(884))
  {
      if(GetLocalInt(oPC, "SPAM_DEFTOT"))
      {
          FloatingTextStringOnCreature("<cþ<<>* No puedes cancelar tan rápidamente el Modo Defensa total *</c>", OBJECT_SELF, FALSE);
          return;
      }

      FloatingTextStringOnCreature("<cþ<<>* Modo Defensa total desactivado *</c>", OBJECT_SELF, FALSE);
      RemoveEffectsFromSpell(oPC, 884);
      SetLocalInt(oPC, "SPAM_DEFTOT", TRUE);
      DelayCommand(6.0, DeleteLocalInt(oPC, "SPAM_DEFTOT"));
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
      FloatingTextStringOnCreature("<cþ<<>* En tu estado no puedes activar el Modo Defensa Total *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // AntiSPAM
  if(GetLocalInt(oPC, "SPAM_DEFTOT"))
  {
      FloatingTextStringOnCreature("<cþ<<>* No puedes reactivar tan rápidamente el Modo Defensa Total *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // INCOMPATIBILIDADES
  // 1. Combatir a la defensiva
  // 2. Pericia en combate
  if(GetHasSpellEffect(883))
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Combatir a la defensiva desactivado *</c>", OBJECT_SELF, FALSE);
      RemoveEffectsFromSpell(oPC, 883);
  }
  if(GetHasSpellEffect(901) || GetHasSpellEffect(904))
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Pericia en combate desactivado *</c>", OBJECT_SELF, FALSE);
      RemoveEffectsFromSpell(oPC, 901);
      RemoveEffectsFromSpell(oPC, 904);
  }

  // Aplicacion de efectos
  effect eAtaque = EffectAttackDecrease(20);
  effect eFalloConjuro = EffectSpellFailure();
  effect eCA = EffectACIncrease(4);
  effect eLink = EffectLinkEffects(eAtaque, eFalloConjuro);
  eLink = EffectLinkEffects(eLink, eCA);
  eLink = ExtraordinaryEffect(eLink);
  FloatingTextStringOnCreature("<c´þd>* Modo Defensa total activado *</c>", oPC, FALSE);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);

  SetLocalInt(oPC, "SPAM_DEFTOT", TRUE);
  DelayCommand(6.0, DeleteLocalInt(oPC, "SPAM_DEFTOT"));
}
