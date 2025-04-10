//::////////////////////////////////////////////////////////////////////////////
//:: On Exit Plano de Fuga                                                //:://
//::////////////////////////////////////////////////////////////////////////////
#include "mti_libreria"
#include "HC_Inc"
//::////////////////////////////////////////////////////////////////////////////
void main()
{
  object oPC = GetExitingObject();
  //Scripts para eliminar los pnj del área.
  ExecuteScript ("z0_area_onexit", oPC);
  // Solo los jugadores activan este script
  if(!GetIsPC(oPC) || GetIsDM(oPC) || GetIsDMPossessed(oPC)) return;

  // Funciones generales
  SetImmortal(oPC, FALSE);
  SPS(oPC, PWS_PLAYER_STATE_ALIVE);

  // Eliminar variables
  GuardarIntPersistente(oPC, "NORESDEIDAD", 0); // Evitar abuso resurreccion por deidad
  GuardarIntPersistente(oPC, "ESTOY_EN_PLANOFUGA", 0); // Ya no esta marcado como muerto
}
