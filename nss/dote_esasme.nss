//::///////////////////////////////////////////////
//:: DOTE ESQUIVA ASOMBROSA MEJORADA
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Esquiva asombrosa mejorada.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 21 de Octubre de 2011
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void main()
{
   object oPC = OBJECT_SELF;

  // Desactivacion del modo
  if(GetHasSpellEffect(986))
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Esquiva asombrosa mejorada desactivado *</c>", oPC, FALSE);
      RemoveEffectsFromSpell(oPC, 986);
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
      FloatingTextStringOnCreature("<cþ<<>* En tu estado no puedes activar el Modo Esquiva asombrosa mejorada *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // Aplicacion de efectos
  effect eImmu = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
  eImmu = ExtraordinaryEffect(eImmu);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmu, oPC);
  FloatingTextStringOnCreature("<c´þd>* Modo Esquiva asombrosa mejorada activado *</c>", OBJECT_SELF, FALSE);
}
