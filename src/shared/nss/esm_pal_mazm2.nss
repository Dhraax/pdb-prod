#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iVariable = ObtenerIntPersistente(oPC, "ESM_PALACIOMAZMORRAS");

  if(iVariable == 1) return TRUE;
  return FALSE;
}
