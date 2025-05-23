#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iVariable = ObtenerIntPersistente(oPC, "ESM_PALACIOMAZMORRAS");

  if(iVariable == 0) return TRUE;
  return FALSE;
}
