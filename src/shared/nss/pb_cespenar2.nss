#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iVariable2 = ObtenerIntPersistente(oPC, "VAR_CESPENAR");
  if(iVariable2 == 1) return TRUE;
  return FALSE;
}
