//::///////////////////////////////////////////////
//:: CANCION 5: Sugestion
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
    Domina 1 criatura.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 7 de Abril de 2011
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void main()
{
  //Declare major variables
  object oMod = GetModule();
  object oTarget = GetSpellTargetObject();
  int nLevel = GetLevelByClass(CLASS_TYPE_BARD, OBJECT_SELF);
  int nPerform = GetSkillRank(SKILL_PERFORM);
  int iCarisma = GetAbilityModifier(ABILITY_CHARISMA);
  int nDuration = 10;
  int nSolturaEncant = 0;
  int bItem = FALSE;

  //Declarando variable de disipacion
  string sVarName = GetName(OBJECT_SELF, TRUE);
  sVarName += IntToString(GetSpellId());
  int nValue = nLevel;

  if(GetIsObjectValid(GetSpellCastItem())) {
      bItem = TRUE;
      nPerform = 9;
      nLevel = GetHitDice(OBJECT_SELF);
  }

  // Si no tenemos usos de cancion de bardo, nanay!
  if(GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF) == FALSE && !bItem)
  {
      FloatingTextStringOnCreature("Necesitas tener usos disponibles de la Canción de bardo para poder cantar esta canción.", OBJECT_SELF, FALSE);
      return;
  }

  // Minimo de Interpretar requerido
  if(nPerform < 9)
  {
      FloatingTextStringOnCreature("Necesitas 9 rangos en Interpretar para poder cantar esta canción.", OBJECT_SELF, FALSE);
      return;
  }

  // Silenciados no se canta
  if(GetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
  {
      FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
      return;
  }

  //Comprobamos si tiene soltura o soltura mayor
  if(GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT) ) nSolturaEncant = 6;
  else if(GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT) ) nSolturaEncant = 4;
  else if(GetHasFeat(FEAT_SPELL_FOCUS_ENCHANTMENT) ) nSolturaEncant = 2;

  //Check to see if the caster has Lasting Impression and increase duration.
  if(GetHasFeat(870))
  {
      nDuration *= 10;
  }

  // lingering song
  if(GetHasFeat(424)) // lingering song
  {
      nDuration += 5;
  }

  // Adios invi
  effect eBad = GetFirstEffect(OBJECT_SELF);
  while(GetIsEffectValid(eBad))
  {
      if(GetEffectType(eBad) == EFFECT_TYPE_ETHEREAL ||
         GetEffectType(eBad) == EFFECT_TYPE_IMPROVEDINVISIBILITY ||
         GetEffectType(eBad) == EFFECT_TYPE_INVISIBILITY ||
         GetEffectType(eBad) == EFFECT_TYPE_SANCTUARY)
      {
          RemoveEffect(OBJECT_SELF, eBad);
      }
      eBad = GetNextEffect(OBJECT_SELF);
  }

  effect eDom = EffectDominated();
  effect eMind = EffectVisualEffect(1961);
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
  effect eVis = EffectVisualEffect(629);
  effect eLink = EffectLinkEffects(eDom, eMind);
  eLink = EffectLinkEffects(eLink, eDur);

  //Fire cast spell at event for the specified target
  SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

  if(GetLocalInt(oTarget, "FASCINADO") &&
     GetLocalInt(oTarget, "NOSUGESTIONADO") == FALSE &&
     GetHasEffect(EFFECT_TYPE_DOMINATED, oTarget) == FALSE &&
     GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS) == FALSE)
  {
      //Make SR Check
      if(!MyResistSpell(OBJECT_SELF, oTarget))
      {
          //Make a Will Save
          if (!MySavingThrow(SAVING_THROW_WILL, oTarget, 10 + (nLevel/2) + iCarisma + nSolturaEncant, SAVING_THROW_TYPE_MIND_SPELLS))
          {
              //Apply linked effects and VFX Impact
              DeleteLocalInt(oTarget, "FASCINADO");
              RemoveEffectsFromSpell(oTarget, 858); // Fascinar
              ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
              ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
              SetLocalInt(oTarget, sVarName, nValue);
          }
          else
          {
              SetLocalInt(oTarget, "NOSUGESTIONADO", TRUE);
              DelayCommand(HoursToSeconds(24), DeleteLocalInt(oTarget, "NOSUGESTIONADO"));
          }
      }
  }

  DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(1855), OBJECT_SELF, 2.0);
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(1846), GetLocation(OBJECT_SELF));
}
