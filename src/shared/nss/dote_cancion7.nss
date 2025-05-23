//::///////////////////////////////////////////////
//:: CANCION 7: Cancion de libertad
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Elimina encantamientos, transmutaciones y maldiciones.
    1 unico objetivo, y no sobre si mismo.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 7 de Abril de 2011
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "pb_nivellanzador"

void main()
{
  //Declare major variables
  object oObjetivo = GetSpellTargetObject();
  int nLevel = GetLevelByClass(CLASS_TYPE_BARD, OBJECT_SELF);
  int nPerform = GetSkillRank(SKILL_PERFORM);

  // Si no tenemos usos de cancion de bardo, nanay!
  if(GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF) == FALSE)
  {
      FloatingTextStringOnCreature("<cþ<<>Necesitas tener usos disponibles de la Canción de bardo para poder cantar esta canción.</c>", OBJECT_SELF, FALSE);
      return;
  }

  // Minimo de Interpretar requerido
  if(nPerform < 15)
  {
      FloatingTextStringOnCreature("<cþ<<>Necesitas 15 rangos en Interpretar para poder cantar esta inspiración.</c>", OBJECT_SELF, FALSE);
      return;
  }

  // Silenciados no se canta
  if(GetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
  {
      FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
      return;
  }

  // Uno mismo de objetivo no se puede
  if(oObjetivo == OBJECT_SELF)
  {
      FloatingTextStringOnCreature("<cþ<<>No se puedes selecionarte a ti mismo como objetivo al cantar la Canción de libertad.</c>", OBJECT_SELF, FALSE);
      return;
  }

  if(nLevel > 15) nLevel = 15;
  int iDadoVeinte, iNivelLanzadorContrincante;

  effect eEfecto = GetFirstEffect(oObjetivo);
  while(GetIsEffectValid(eEfecto))
  {
      if((GetEffectType(eEfecto) == EFFECT_TYPE_BLINDNESS ||
          GetEffectType(eEfecto) == EFFECT_TYPE_CHARMED ||
          GetEffectType(eEfecto) == EFFECT_TYPE_CONFUSED ||
          GetEffectType(eEfecto) == EFFECT_TYPE_CURSE ||
          GetEffectType(eEfecto) == EFFECT_TYPE_DAZED ||
          GetEffectType(eEfecto) == EFFECT_TYPE_DEAF ||
          GetEffectType(eEfecto) == EFFECT_TYPE_DOMINATED ||
          GetEffectType(eEfecto) == EFFECT_TYPE_PARALYZE ||
          GetEffectType(eEfecto) == EFFECT_TYPE_PETRIFY ||
          GetEffectType(eEfecto) == EFFECT_TYPE_SLOW ||
          GetEffectType(eEfecto) == EFFECT_TYPE_STUNNED) &&
          GetEffectSubType(eEfecto) == SUBTYPE_MAGICAL ||
          (GetEffectType(eEfecto) == EFFECT_TYPE_CURSE && GetEffectSubType(eEfecto) == SUBTYPE_SUPERNATURAL)
          )
      {
          iDadoVeinte = d20();
          iNivelLanzadorContrincante = GetTotalCasterLevel(GetEffectCreator(eEfecto));
          if(iDadoVeinte + nLevel >= 11 + iNivelLanzadorContrincante)
          {
              SendMessageToPC(OBJECT_SELF, "<c´þd>Prueba de nivel de lanzador: "+IntToString(iDadoVeinte+nLevel)+" contra CD: "+IntToString(11+iNivelLanzadorContrincante)+". *Éxito*</c>");
              RemoveEffect(oObjetivo, eEfecto);
          }
          else SendMessageToPC(OBJECT_SELF, "<cþ<<>Prueba de nivel de lanzador: "+IntToString(iDadoVeinte+nLevel)+" contra CD: "+IntToString(11+iNivelLanzadorContrincante)+". *Fracaso*</c>");
      }

      eEfecto = GetNextEffect(oObjetivo);
  }

  DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(1855), OBJECT_SELF, 2.0);
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(1846), GetLocation(OBJECT_SELF));
}
