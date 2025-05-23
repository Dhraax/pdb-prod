#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iVariable = ObtenerIntPersistente(oPC, "VAR_CESPENAR");
  if(iVariable == 0) return TRUE;
  return FALSE;
}
