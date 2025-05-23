//::////////////////////////////////////////////////////////////////////////////
//:: Nombre del guion:  hc_on_ply_respwn                                  //:://
//::////////////////////////////////////////////////////////////////////////////
//:: GUION ORIGINAL HCR 3.3b                                              //:://
//:: Modificado para el servidor Puerta de Baldur                         //:://
//::////////////////////////////////////////////////////////////////////////////
#include "cab_inc"
#include "hc_inc_remeff"
#include "tj_inc"
#include "inc_sum_golem"
#include "inc_sqlite_time"

void main()
{
  object oPC = GetLastRespawnButtonPresser();

  // ELIMINAR LAS VARIABLES DEL PUESTO DE VENTA (si lo tiene montado)
  DelayCommand(1.0, EliminarVariablesTJ(oPC));

  //Golem System
  KillActiveGolem(oPC);

  // RESUCITAR AL JUGADOR Y ELIMINAR CUALQUIER EFECTO NEGATIVO
  int nHeal = GetMaxHitPoints(oPC);
  effect eHeal = EffectHeal(nHeal);
  effect eRez  = EffectResurrection();
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eRez,  oPC);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
  RemoveEffectsHCR(oPC);

  // APLICAMOS LOS EFECTOS DE LAS SUBRAZAS, MONTURAS Y ARMADURAS
  ReaplicarEfectosPB(oPC,TRUE);

  // REGENERAR EN ARENAS
  if(GetLocalInt(oPC, "ARENA") == 1) return;

  // REGENERAR EN CAMPOS DE BATALLA
  if(GetLocalInt(oPC, "CAMPOBATALLA") == 1){
    DeleteLocalInt(oPC, "CAMPOBATALLA");
    DelayCommand(0.3, AssignCommand(oPC, ActionJumpToLocation(GetStartingLocation())));
    return;
  }

  // Funciones del cadaver
  string sResrefCadaver;
  string sSubrazaCadaver = GetStringLowerCase(GetSubRace(oPC));
  if(sSubrazaCadaver == "ghul") sResrefCadaver = "pg_cadaver9";
  else if(sSubrazaCadaver == "kobold" || sSubrazaCadaver == "trasgo") sResrefCadaver = "pg_cadaver3";
  else if(sSubrazaCadaver == "gran trasgo") sResrefCadaver = "pg_cadaver4";
  else if(sSubrazaCadaver == "minotauro" || sSubrazaCadaver == "ogro" || sSubrazaCadaver == "semiogro") sResrefCadaver = "pg_cadaver7";
  else if(sSubrazaCadaver == "orco") sResrefCadaver = "pg_cadaver6";
  else if(sSubrazaCadaver == "osgo") sResrefCadaver = "pg_cadaver5";
  else if(sSubrazaCadaver == "ogro hechicero") sResrefCadaver = "pg_cadaver8";
  else
  {
      if(GetGender(oPC) == GENDER_MALE) sResrefCadaver = "pg_cadaver1";
      else sResrefCadaver = "pg_cadaver2";
  }

  string sNombreCadaver = GetName(oPC);
  object oCadaverJugador = CreateObject(OBJECT_TYPE_PLACEABLE, sResrefCadaver, GetLocation(oPC), FALSE);
  SetName(oCadaverJugador, "Cadáver de " + sNombreCadaver);

  SetLocalString(oCadaverJugador, "CAD_NOMBRE", sNombreCadaver);
  SetLocalString(oCadaverJugador, "CAD_RESREF", sResrefCadaver);
  SetLocalObject(oCadaverJugador, "CAD_JUGADOR", oPC);
  SetLocalObject(GetModule(), "CAD_" + sNombreCadaver, oCadaverJugador);

  // Variable persistente: ESTOY MUERTO
  int iNivelPJ = GetHitDice(oPC);
  int iHorasDeEspera;
  if(iNivelPJ >= 1 && iNivelPJ <= 4) iHorasDeEspera = 2;
  else if(iNivelPJ >= 5 && iNivelPJ <= 8) iHorasDeEspera = 3;
  else if(iNivelPJ >= 9 && iNivelPJ <= 12) iHorasDeEspera = 4;
  else if(iNivelPJ >= 13 && iNivelPJ <= 16) iHorasDeEspera = 5;
  else iHorasDeEspera = 6;
  iHorasDeEspera = iHorasDeEspera * 180;
  GuardarIntPersistente(oPC, "ESTOY_EN_PLANOFUGA", SQLite_GetTimeStamp() + iHorasDeEspera);

  // DESMONTAR DEL CABALLO/PONY
  MorirEncimaDeMontura(oPC);

  // MANDAR AL JUGADOR AL PLANO DE LA FUGA
  location lAbismo = GetLocation(GetWaypointByTag("pg_planofuga"));
  AssignCommand(oPC, JumpToLocation(lAbismo));
}
