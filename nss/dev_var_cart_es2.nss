#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oCarta = GetItemPossessedBy(oPC, "CartaalaUniversidaddeAthkatla");
  int iVariable = ObtenerIntPersistente(oPC, "CARTA_SECR_ESMEL");

  if(iVariable == 1 && oCarta != OBJECT_INVALID) return TRUE;
  return FALSE;
}
