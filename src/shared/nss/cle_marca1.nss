#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(ObtenerIntPersistente(oPC, "PALABRA_REGRESO_LOC1") == TRUE) return TRUE;

  return FALSE;
}
