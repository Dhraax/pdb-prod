//::///////////////////////////////////////////////
//:: ALLEGRO DEL VIGOR DE MILCANTES
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Regenera.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 10 de Abril de 2011
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
  int nDuration = 10;
  int nPerform = GetSkillRank(SKILL_PERFORM);
  effect eRegeneracion = EffectRegenerate(nPerform/7, 6.0);

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
  if(nPerform < 12)
  {
      FloatingTextStringOnCreature("Necesitas 12 rangos en Interpretar para poder cantar esta canción.", OBJECT_SELF, FALSE);
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

  AssignCommand(OBJECT_SELF,PlaySound("as_cv_lute1"));

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
              ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRegeneracion, oTarget, RoundsToSeconds(nDuration));
              SetLocalInt(oTarget, sVarName, nValue);
          }
      }
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
  }

  DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(1855), OBJECT_SELF, RoundsToSeconds(nDuration));
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(1846), GetLocation(OBJECT_SELF));
}
