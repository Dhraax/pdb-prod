//::///////////////////////////////////////////////
//:: CANCION 4: Infundir gran aptitud
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Concede un bonificador de habilidad a todos los aliados que comienza
    siendo +2 y pasa a ser +4 en nivel 11 y +6 en nivel 19.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 5 de Abril de 2011
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void EliminarAntiguasCancionesBeneficiosas(object oObjetivo)
{
  RemoveEffectsFromSpell(oObjetivo, 857); // Contraoda
  RemoveEffectsFromSpell(oObjetivo, 859); // Infundir valor
  RemoveEffectsFromSpell(oObjetivo, 860); // Infundir gran aptitud
  RemoveEffectsFromSpell(oObjetivo, 862); // Infundir grandeza
  RemoveEffectsFromSpell(oObjetivo, 864); // Infundir heroicidad
  RemoveEffectsFromSpell(oObjetivo, 868); // Allegro del vigor de Milcantes
}

void main()
{
  //Declare major variables
  int nLevel = GetLevelByClass(CLASS_TYPE_BARD, OBJECT_SELF);
  int nPerform = GetSkillRank(SKILL_PERFORM);
  int nDuration = 10;
  int nBonus;

  // Si no tenemos usos de cancion de bardo, nanay!
  if(GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF) == FALSE)
  {
      FloatingTextStringOnCreature("Necesitas tener usos disponibles de la Canción de bardo para poder cantar esta canción.", OBJECT_SELF, FALSE);
      return;
  }

  // Minimo de Interpretar requerido
  if(nPerform < 6)
  {
      FloatingTextStringOnCreature("Necesitas 6 rangos en Interpretar para poder cantar esta inspiración.", OBJECT_SELF, FALSE);
      return;
  }

  // Silenciados no se canta
  if(GetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
  {
      FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
      return;
  }

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

  if(nLevel >= 19)        nBonus = 6;
  else if(nLevel >= 11)   nBonus = 4;
  else                    nBonus = 2;

  effect eHabilidades = EffectSkillIncrease(SKILL_ALL_SKILLS, nBonus);
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

  effect eLink = EffectLinkEffects(eHabilidades, eDur);
  eLink = ExtraordinaryEffect(eLink);

  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
  while(GetIsObjectValid(oTarget))
  {
      // Si estamos silenciados, no escuchamos la cancion!
      if(!GetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !GetHasEffect(EFFECT_TYPE_DEAF,oTarget))
      {
          // Solos a los colegas (nos incluimos)
          if(GetIsFriend(oTarget))
          {
              EliminarAntiguasCancionesBeneficiosas(oTarget);
              if(oTarget != OBJECT_SELF) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_SONIC), oTarget);
              ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
          }
      }
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
  }

  DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
  //El efecto visual del bardo cantando ya no se disipa.
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectVisualEffect(1855)), OBJECT_SELF, RoundsToSeconds(nDuration));
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(1846), GetLocation(OBJECT_SELF));
}
