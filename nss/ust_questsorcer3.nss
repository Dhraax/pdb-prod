#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(ObtenerIntPersistente(oPC, "QUESTSORCERE") == 1) return TRUE;

  return FALSE;
}
