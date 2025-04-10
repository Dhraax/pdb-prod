//::///////////////////////////////////////////////
//:: CANCION 6: Infundir grandeza
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    2d10 puntos de golpe temporales + con del objetivo
    +2 ataque
    +1 salvacion fortaleza
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
  if(nPerform < 12)
  {
      FloatingTextStringOnCreature("Necesitas 12 rangos en Interpretar para poder cantar esta inspiración.", OBJECT_SELF, FALSE);
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
  if(nLevel >= 21)        iCriaturasMaximas = 5;
  else if(nLevel >= 18)   iCriaturasMaximas = 4;
  else if(nLevel >= 15)   iCriaturasMaximas = 3;
  else if(nLevel >= 12)   iCriaturasMaximas = 2;

  effect ePuntosDeGolpeTemporales;
  effect eAtaque = EffectAttackIncrease(2);
  effect eSalvaciones = EffectSavingThrowIncrease(SAVING_THROW_FORT, 1);
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

  effect eLink = EffectLinkEffects(eAtaque, eSalvaciones);
  eLink = EffectLinkEffects(eLink, eDur);
  eLink = ExtraordinaryEffect(eLink);

  // Aplicamos el efecto al objetivo
  if(!GetIsEnemy(GetSpellTargetObject()))
  {
      iCriaturasMaximas--;
      EliminarAntiguasCancionesBeneficiosas(GetSpellTargetObject());
      ePuntosDeGolpeTemporales = EffectTemporaryHitpoints(d10(2) + (GetAbilityModifier(ABILITY_CONSTITUTION, GetSpellTargetObject()) * 2));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_SONIC), GetSpellTargetObject());
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, GetSpellTargetObject(), RoundsToSeconds(nDuration));
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePuntosDeGolpeTemporales, GetSpellTargetObject(), RoundsToSeconds(nDuration));
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

              ePuntosDeGolpeTemporales = EffectTemporaryHitpoints(d10(2) + (GetAbilityModifier(ABILITY_CONSTITUTION, oTarget) * 2));

              ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_SONIC), oTarget);
              ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
              ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePuntosDeGolpeTemporales, oTarget, RoundsToSeconds(nDuration));
          }
      }
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation());
  }

  // Quitamos uso dote y efectos visuales de la musica
  DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
  //El efecto visual del bardo cantando ya no se disipa.
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectVisualEffect(1855)), OBJECT_SELF, RoundsToSeconds(nDuration));
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(1846), GetLocation(OBJECT_SELF));
}
