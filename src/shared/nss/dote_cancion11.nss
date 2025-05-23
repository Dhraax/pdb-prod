//::///////////////////////////////////////////////
//:: TROMPETEO BREVE DE MIRLAC
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Ciega y ensordece a las criaturas.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 10 de Abril de 2011
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void main()
{
  //Declare major variables
  int nPerform = GetSkillRank(SKILL_PERFORM);
  int iCD = 10 + (nPerform/2);
  int nDuration = 10;
  int nSolturaEncant = 0;
  effect eBlind =  EffectBlindness();
  effect eDeaf = EffectDeaf();
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

  effect eLink = EffectLinkEffects(eBlind, eDeaf);
  eLink = EffectLinkEffects(eLink, eDur);

  //Declarando variable de disipacion
  string sVarName = GetName(OBJECT_SELF, TRUE);
  sVarName += IntToString(GetSpellId());
  int nValue = GetLevelByClass(CLASS_TYPE_BARD, OBJECT_SELF);

  // Si no tenemos usos de cancion de bardo, nanay!
  if(GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF) == FALSE)
  {
      FloatingTextStringOnCreature("Necesitas tener usos disponibles de la Canción de bardo para poder cantar esta canción.", OBJECT_SELF, FALSE);
      return;
  }

  // Minimo de Interpretar requerido
  if(nPerform < 13)
  {
      FloatingTextStringOnCreature("Necesitas 13 rangos en Interpretar para poder cantar esta canción.", OBJECT_SELF, FALSE);
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

  AssignCommand(OBJECT_SELF,PlaySound("as_cv_ta-da1"));

  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
  while(GetIsObjectValid(oTarget))
  {
      if(GetIsEnemy(oTarget))
      {
          //Make SR Check
          if(!MyResistSpell(OBJECT_SELF, oTarget))
          {
              if (!/*Fort Save*/ MySavingThrow(SAVING_THROW_FORT, oTarget, iCD + nSolturaEncant))
              {
                  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(670), oTarget);
                  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                  SetLocalInt(oTarget, sVarName, nValue);
              }
          }
      }
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
  }

  DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(1855), OBJECT_SELF, 2.0);
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(1846), GetLocation(OBJECT_SELF));
}
