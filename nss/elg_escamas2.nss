#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iEscamasDragonNiebla = ObtenerIntPersistente(oPC, "ESCAMASDRAGNIEBLA");

  if(iEscamasDragonNiebla == 1) return TRUE;

  return FALSE;
}
