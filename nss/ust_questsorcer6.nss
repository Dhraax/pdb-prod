#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(ObtenerIntPersistente(oPC, "QUESTSORCERE") == 2) return TRUE;

  return FALSE;
}
