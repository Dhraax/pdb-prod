#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iVariable = ObtenerIntPersistente(oPC, "ESM_PALACIOHIERBAS");

  if(iVariable == 2) return TRUE;
  return FALSE;
}
