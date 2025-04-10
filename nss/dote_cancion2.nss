//::///////////////////////////////////////////////
//:: CANCION 2: Fascinar
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Aturde a las criaturas.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 7 de Abril de 2011
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void main()
{
  //Declare major variables
  int nPerform = GetSkillRank(SKILL_PERFORM);
  int nLevel = GetLevelByClass(CLASS_TYPE_BARD, OBJECT_SELF);
  int nDuration = 5;
  int nSolturaEncant = 0;

  //Declarando variable de disipacion
  string sVarName = GetName(OBJECT_SELF, TRUE);
  sVarName += IntToString(GetSpellId());
  int nValue = nLevel;

  // Si no tenemos usos de cancion de bardo, nanay!
  if(GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF) == FALSE)
  {
      FloatingTextStringOnCreature("Necesitas tener usos disponibles de la Canción de bardo para poder cantar esta canción.", OBJECT_SELF, FALSE);
      return;
  }

  // Minimo de Interpretar requerido
  if(nPerform < 3)
  {
      FloatingTextStringOnCreature("Necesitas 3 rangos en Interpretar para poder cantar esta canción.", OBJECT_SELF, FALSE);
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

  effect eHechizado = EffectCharmed();
  effect eMind = EffectVisualEffect(1853);
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

  effect eLink = EffectLinkEffects(eHechizado, eMind);
  eLink = EffectLinkEffects(eLink, eDur);

  int iCriaturasMaximas = 1;
  if(nLevel >= 22) iCriaturasMaximas = 8;
  else if(nLevel >= 19) iCriaturasMaximas = 7;
  else if(nLevel >= 16) iCriaturasMaximas = 6;
  else if(nLevel >= 13) iCriaturasMaximas = 5;
  else if(nLevel >= 10) iCriaturasMaximas = 4;
  else if(nLevel >= 7) iCriaturasMaximas = 3;
  else if(nLevel >= 4) iCriaturasMaximas = 2;

  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), TRUE);
  while(GetIsObjectValid(oTarget) && iCriaturasMaximas != 0)
  {
      if(GetIsEnemy(oTarget) &&
         GetCurrentHitPoints(oTarget) > 0 &&
         GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS) == FALSE)
      {
          if(!GetLocalInt(oTarget, "NOFASCINADO"))
          {
              iCriaturasMaximas--;

              //Make SR Check
              if(!MyResistSpell(OBJECT_SELF, oTarget))
              {
                  //Make a Will roll to avoid being stunned
                  if(!MySavingThrow(SAVING_THROW_WILL, oTarget, d20() + (nPerform/2) + nSolturaEncant, SAVING_THROW_TYPE_MIND_SPELLS))
                  {
                      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                      SetLocalInt(oTarget, "FASCINADO", TRUE);
                      SetLocalInt(oTarget, sVarName, nValue);
                      DelayCommand(RoundsToSeconds(nDuration), DeleteLocalInt(oTarget, "FASCINADO"));
                  }
                  else
                  {
                      SetLocalInt(oTarget, "NOFASCINADO", TRUE);
                      DelayCommand(HoursToSeconds(24), DeleteLocalInt(oTarget, "NOFASCINADO"));
                  }
              }
          }
      }
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), TRUE);
  }

  DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(1855), OBJECT_SELF, 2.0);
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(1846), GetLocation(OBJECT_SELF));
}
