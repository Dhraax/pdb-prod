//::///////////////////////////////////////////////
//:: FURIA BARBARA
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Furia barbara.
    Dotes: Furia Mayor, Furia Incansable, Furia Poderosa.
    Peculiaridades: Fatiga.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 7 de Junio de 2010
//:://////////////////////////////////////////////

#include "x2_i0_spells"
#include "nostack_inc"

void AjustesFatiga(object oPC, effect eEffect)
{
  if(GetHasFeatEffect(FEAT_BARBARIAN_RAGE, oPC))
  {
      if(GetLocalInt(oPC, "FATIGADO") == TRUE)
      {
          if(GetIsInCombat(oPC) == TRUE) DelayCommand(10.0, AjustesFatiga(oPC, eEffect));
          else
          {
              RemoveEffect(oPC, eEffect);
              DeleteLocalInt(oPC, "FATIGADO");
          }
      }
      else DelayCommand(10.0, AjustesFatiga(oPC, eEffect));
  }
  else if(GetIsInCombat(oPC) == TRUE)
  {
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oPC);
      SendMessageToPC(oPC, "<cþ<<>Estás fatigado a causa de la furia, deja de combatir y volverás a la normalidad.</c>");
      SetLocalInt(oPC, "FATIGADO", TRUE);
      DelayCommand(10.0, AjustesFatiga(oPC, eEffect));
  }
}

void main()
{
  object oPC = OBJECT_SELF;
  int iFuriaMayor = GetHasFeat(1308, oPC);
  int iVoluntadIndomable = GetHasFeat(1326, oPC);
  int iFuriaIncansable = GetHasFeat(1309, oPC);
  int iFuriaPoderosa = GetHasFeat(1310, oPC);
  int iNivelBarbaro = GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC);
  int iNivel = GetHitDice(oPC);
  int nIncrease;
  int nSave;

  //si estas en furia dejaras de estarlo, pero el cansancio lo tendras igualmente
  if(GetHasFeatEffect(FEAT_BARBARIAN_RAGE, oPC))
  {
     FloatingTextStringOnCreature("<cþ<<>Consigues calmarte y abandonas tu estado de furia.</c>", oPC, FALSE);
     RemoveSpellEffects(SPELLABILITY_BARBARIAN_RAGE, oPC, oPC);
     IncrementRemainingFeatUses(oPC, FEAT_BARBARIAN_RAGE);
     return;
  }

  if(iFuriaPoderosa == TRUE)
  {
      nIncrease = 8;
      nSave = 4;
  }
  else
  {
      if(iFuriaMayor == TRUE)
      {
          nIncrease = 6;
          nSave = 3;
      }
      else
      {
          nIncrease = 4;
          nSave = 2;
      }
  }

  //Calculamos si el bono magico que ganamos es mayor que el maximo (si es positivo)
  //Determine the duration by getting the con modifier after being modified
  int nBonoAtaque = (GetAbilityScore(oPC, ABILITY_STRENGTH, FALSE) - GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE) + nIncrease -12) / 2;
  int nBonoVida = (GetAbilityScore(oPC, ABILITY_CONSTITUTION, FALSE) - GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE) + nIncrease -12) / 2 *iNivel;
  int nCon = 3 + GetAbilityModifier(ABILITY_CONSTITUTION) + nIncrease;
  effect eHP;
  effect eAC = EffectACDecrease(2, AC_DODGE_BONUS);
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
  effect eFallo = EffectSpellFailure(100);
  effect eFuerza = EffectAbilityIncrease(ABILITY_STRENGTH, nIncrease);
  effect eConsti = EffectAbilityIncrease(ABILITY_CONSTITUTION, nIncrease);
  effect eVolun1 = EffectSavingThrowIncrease(SAVING_THROW_WILL, nSave);
  effect eVolun2 = EffectSavingThrowIncrease(SAVING_THROW_WILL, nSave + 4, SAVING_THROW_TYPE_MIND_SPELLS);
  effect eLink = EffectLinkEffects(eAC, eDur);
  eLink = EffectLinkEffects(eLink, eFallo);
  eLink = EffectLinkEffects(eLink, eFuerza);
  eLink = EffectLinkEffects(eLink, eConsti);
  eLink = EffectLinkEffects(eLink, eVolun1);
  if(iVoluntadIndomable == TRUE)  eLink = EffectLinkEffects(eLink, eVolun2);

  //Si tiene los bonos magicos a las caracterisitcas da bono de ataque y vida.
  if(nBonoAtaque > 0)
  {
      eLink = EffectLinkEffects(eLink, EffectAttackIncrease(nBonoAtaque));
      eLink = EffectLinkEffects(eLink, EffectDamageIncrease(nBonoAtaque, DAMAGE_TYPE_BLUDGEONING));
  }
  if(nBonoVida > 0)
  {
      eHP = EffectTemporaryHitpoints(nBonoVida);
      eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_FORT, nBonoVida/iNivel));
  }

  //Make effect extraordinary
  eLink = ExtraordinaryEffect(eLink);
  eHP = ExtraordinaryEffect(eHP);

  //Apply the VFX impact and effects
  PlayVoiceChat(VOICE_CHAT_BATTLECRY1);
  SignalEvent(oPC, EventSpellCastAt(oPC, SPELLABILITY_BARBARIAN_RAGE, FALSE));
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(nCon));
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oPC, RoundsToSeconds(nCon));
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE), oPC) ;

  // 2003-07-08, Georg: Rage Epic Feat Handling
  CheckAndApplyEpicRageFeats(nCon);

  // Desactivacion del modo pericia
  if(GetHasSpellEffect(901) || GetHasSpellEffect(904))
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Pericia en combate desactivado *</c>", OBJECT_SELF, FALSE);
      RemoveEffectsFromSpell(oPC, 901);
      RemoveEffectsFromSpell(oPC, 904);
  }

  // Ajustes de fatiga
  if(iFuriaIncansable == FALSE)
  {
      effect eStrDec = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
      effect eDexDec = EffectAbilityDecrease(ABILITY_DEXTERITY, 2);
      effect eSlow   = EffectMovementSpeedDecrease(50);
      effect eEffect = EffectLinkEffects(eDexDec, eStrDec);
      eEffect = EffectLinkEffects(eEffect, eSlow);
      DelayCommand(10.0, AjustesFatiga(oPC, eEffect));
  }
}
