//::///////////////////////////////////////////////
//:: CANCION 3: Infundir valor
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Concede un bonificador al ataque, daño, tiradas contra miedo y conjuros
    enajenadores que comienza siendo +1 y pasa a ser +2 en nivel 8,
    +3 en nivel 14 y +4 en nivel 20.
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
  int nDuration = 10; // en teoria dura 5 asaltos cuando deje de cantar, duracion media... pues 10
  int nBonus, nDamage;

  // Si no tenemos usos de cancion de bardo, nanay!
  if(GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF) == FALSE)
  {
      FloatingTextStringOnCreature("Necesitas tener usos disponibles de la Canción de bardo para poder cantar esta canción.", OBJECT_SELF, FALSE);
      return;
  }

  // Minimo de Interpretar requerido
  if(nPerform < 3)
  {
      FloatingTextStringOnCreature("Necesitas 3 rangos en Interpretar para poder cantar esta inspiración.", OBJECT_SELF, FALSE);
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

  if(nLevel >= 20)       { nBonus = 4; nDamage = DAMAGE_BONUS_4; }
  else if(nLevel >= 14)  { nBonus = 3; nDamage = DAMAGE_BONUS_3; }
  else if(nLevel >= 8)   { nBonus = 2; nDamage = DAMAGE_BONUS_2; }
  else                   { nBonus = 1; nDamage = DAMAGE_BONUS_1; }

  effect eSave1 = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus, SAVING_THROW_TYPE_FEAR);
  effect eSave2 = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus, SAVING_THROW_TYPE_MIND_SPELLS);
  effect eAttack = EffectAttackIncrease(nBonus);
  effect eDamage = EffectDamageIncrease(nDamage, DAMAGE_TYPE_BLUDGEONING);
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

  effect eLink = EffectLinkEffects(eSave1, eSave2);
  eLink = EffectLinkEffects(eLink, eAttack);
  eLink = EffectLinkEffects(eLink, eDamage);
  eLink = EffectLinkEffects(eLink, eDur);
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
