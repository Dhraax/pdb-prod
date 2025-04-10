#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(ObtenerIntPersistente(oPC, "PALABRA_REGRESO_LOC3") == FALSE) return TRUE;

  return FALSE;
}
