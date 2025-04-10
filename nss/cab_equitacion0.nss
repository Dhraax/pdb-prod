#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oHabilidadEquitacion = GetItemPossessedBy(oPC, "cab_equitacion");
  int iNivelEquitacion = ObtenerIntPersistente(oPC, "NIVELEQUITACION");

  if(oHabilidadEquitacion == OBJECT_INVALID && iNivelEquitacion == 0) return TRUE;

  return FALSE;
}
