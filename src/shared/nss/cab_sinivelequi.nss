#include "cab_inc"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iNivelEquitacion = ObtenerIntPersistente(oPC, "NIVELEQUITACION");
  int iXPEquitacion = ObtenerIntPersistente(oPC, "NIVELEQUITACIONXP");

  if(iNivelEquitacion == 0 || iNivelEquitacion == 100 || iXPEquitacion == 0) return FALSE;

  if(iXPEquitacion >= CalculoSiguienteNivelXPEquitacion(iNivelEquitacion)) return TRUE;

  return FALSE;
}
