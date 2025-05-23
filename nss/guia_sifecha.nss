#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(ObtenerIntPersistente(oPC, "PB_FECHA_CREACION") == FALSE) return FALSE;

  return TRUE;
}
