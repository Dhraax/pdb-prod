#include "f_vampire_area_h"
#include "mti_libreria"
#include "nwnx_creature"

void main ()
{
  object oPC = GetEnteringObject();

  if(GetIsDM(oPC) || GetIsDMPossessed(oPC)) return;

  object areamar = GetArea(oPC);
  effect dope1 = EffectTemporaryHitpoints(100);
  effect dope2 = EffectDamageReduction(10,DAMAGE_POWER_PLUS_SIX,0);
  effect dope3 = EffectACIncrease(5,AC_NATURAL_BONUS,AC_VS_DAMAGE_TYPE_ALL);

  int rangoocul = GetSkillRank(SKILL_HIDE,oPC,TRUE);
  int rangomovsig = GetSkillRank(SKILL_MOVE_SILENTLY,oPC,TRUE);

  if(GetIsPC(oPC))
  {
      if(GetIsObjectValid(GetItemPossessedBy(oPC, "Canonazos")) == FALSE) CreateItemOnObject("canonazos", oPC);
      if(GetIsObjectValid(GetItemPossessedBy(oPC, "ApoyomagicoenMar")) == FALSE) CreateItemOnObject("apoyoarcanoenmar", oPC);
      //if(GetIsObjectValid(GetItemPossessedBy(oPC, "AparienciadelBarco")) == FALSE) CreateItemOnObject("aparienciadelbar", oPC);
      if(GetIsObjectValid(GetItemPossessedBy(oPC, "cartasdenavegaci")) == TRUE) ExploreAreaForPlayer(areamar,oPC,TRUE);

      Vampire_Enter(oPC, FALSE);
      GuardarIntPersistente(oPC, "MAR_APA_CAMBIADA", TRUE);
      GuardarIntPersistente(oPC, "MAR_APA_MEMORIZADA", GetAppearanceType(oPC));
      GuardarIntPersistente(oPC, "MAR_COLA_CAMBIADA", TRUE);
      GuardarIntPersistente(oPC, "MAR_COLA_MEMORIZADA", GetCreatureTailType(oPC));
      GuardarIntPersistente(oPC, "MAR_ALAS_CAMBIADAS", TRUE);
      GuardarIntPersistente(oPC, "MAR_ALAS_MEMORIZADAS", GetCreatureWingType(oPC));
      GuardarIntPersistente(oPC, "CHUTES_BARCO", TRUE);
      GuardarIntPersistente(oPC, "TIPO_BARCO",TRUE);
      SetCreatureAppearanceType(oPC, 3881); //2880
      SetCreatureTailType (3021, oPC); //3021
      SetCreatureWingType (0, oPC);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, dope1, oPC);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, dope2, oPC);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, dope3, oPC);

      if(rangoocul > 0)
      {
          GuardarIntPersistente(oPC,"VALOR_HIDE",rangoocul);
          GuardarIntPersistente(oPC,"HIDE_OFF",TRUE);
          NWNX_Creature_SetSkillRank (oPC,SKILL_HIDE,0);
      }

      if(rangomovsig > 0)
      {
          GuardarIntPersistente(oPC,"VALOR_MOVE_SILENTLY",rangomovsig);
          GuardarIntPersistente(oPC,"MOVE_SILENTLY_OFF",TRUE);
          NWNX_Creature_SetSkillRank (oPC,SKILL_MOVE_SILENTLY,0);
      }
  }
}
