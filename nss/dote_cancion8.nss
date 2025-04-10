//::///////////////////////////////////////////////
//:: CANCION 8: Infundir heroicidad
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    +4 TS y +4 CA
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 7 de Abril de 2011
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void EliminarAntiguasCancionesBeneficiosas(object oObjetivo)
{
  RemoveEffectsFromSpell(oObjetivo, 857); // Contraoda
  RemoveEffectsFromSpell(oObjetivo, 859); // Infundir valor
  RemoveEffectsFromSpell(oObjetivo, 860); // Infundir gran aptitud
  RemoveEffectsFromSpell(oObjetivo, 862); // Infundir grandeza
  RemoveEffectsFromSpell(oObjetivo, 863); // Cancion de libertad
  RemoveEffectsFromSpell(oObjetivo, 864); // Infundir heroicidad
  RemoveEffectsFromSpell(oObjetivo, 868); // Allegro del vigor de Milcantes
}

void main()
{
  //Declare major variables
  int nLevel = GetLevelByClass(CLASS_TYPE_BARD, OBJECT_SELF);
  int nPerform = GetSkillRank(SKILL_PERFORM);
  int nDuration = 10;

  // Si no tenemos usos de cancion de bardo, nanay!
  if(GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF) == FALSE)
  {
      FloatingTextStringOnCreature("Necesitas tener usos disponibles de la Canción de bardo para poder cantar esta canción.", OBJECT_SELF, FALSE);
      return;
  }

  // Minimo de Interpretar requerido
  if(nPerform < 18)
  {
      FloatingTextStringOnCreature("Necesitas 18 rangos en Interpretar para poder cantar esta inspiración.", OBJECT_SELF, FALSE);
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

  int iCriaturasMaximas = 1;
  if(nLevel >= 21)        iCriaturasMaximas = 3;
  else if(nLevel >= 18)   iCriaturasMaximas = 2;

  effect eCA = EffectACIncrease(4);
  effect eSalvaciones = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4);
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

  effect eLink = EffectLinkEffects(eCA, eSalvaciones);
  eLink = EffectLinkEffects(eLink, eDur);
  eLink = ExtraordinaryEffect(eLink);

  // Aplicamos el efecto al objetivo
  if(!GetIsEnemy(GetSpellTargetObject()))
  {
      iCriaturasMaximas--;
      EliminarAntiguasCancionesBeneficiosas(GetSpellTargetObject());
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_SONIC), GetSpellTargetObject());
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, GetSpellTargetObject(), RoundsToSeconds(nDuration));
  }

  // Y luego lo aplicamos a los demas
  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation());
  while(GetIsObjectValid(oTarget) && iCriaturasMaximas != 0)
  {
      // Si estamos silenciados, no escuchamos la cancion!
      if(!GetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !GetHasEffect(EFFECT_TYPE_DEAF,oTarget))
      {
          // Solos a los colegas
          if(!GetIsEnemy(oTarget) && oTarget != GetSpellTargetObject())
          {
              iCriaturasMaximas--;

              EliminarAntiguasCancionesBeneficiosas(oTarget);
              ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_SONIC), oTarget);
              ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
          }
      }
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation());
  }

  // Quitamos uso dote y efectos visuales de la musica
  DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
  // El efecto visual del bardo cantando ya no se disipa.
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectVisualEffect(1855)), OBJECT_SELF, RoundsToSeconds(nDuration));
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(1846), GetLocation(OBJECT_SELF));
}
