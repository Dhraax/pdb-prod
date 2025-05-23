#include "inc_sqlite_time"

int VerSiHayEnemigosEnRango(object oCriatura, float fRango)
{
  object oNextCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oCriatura);
  float fDist;
  if(oNextCreature != OBJECT_INVALID) fDist = GetDistanceBetween(oCriatura, oNextCreature);
  int nLooper;
  while(fDist <= fRango && oNextCreature != OBJECT_INVALID)
  {
      if(GetIsEnemy(oNextCreature, oCriatura)) return TRUE;
      oNextCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oCriatura, ++nLooper);
      if(oNextCreature != OBJECT_INVALID) fDist = GetDistanceBetween(oCriatura, oNextCreature);
  }

  return FALSE;
}

void main()
{
  object oPC = GetLastUsedBy();
  object oMod = GetModule();
  int iTiempoMemorizado = GetLocalInt(oPC, "QUEST_TS_TIEMPO_PLANO");
  int iRestaTiempo = SQLite_GetTimeStamp() - iTiempoMemorizado;

  // No hay enemigos cercanos? Entonces podemos
  // Ha pasado 10 minutos desde que entre al area? Tambien podemos
  if(VerSiHayEnemigosEnRango(oPC, 100.0) == FALSE || iRestaTiempo >= 900)
  {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), oPC);
        AssignCommand(oPC, JumpToObject(GetWaypointByTag("quest_ts_portal_out")));
  }

  // En el resto de casos no
  else
  {
      FloatingTextStringOnCreature("<cþ<<>* Portal cerrado. Quizás el paso del tiempo o la destrucción de las criaturas cercanas puedan abrirlo. *</c>", oPC, FALSE);
  }
}
