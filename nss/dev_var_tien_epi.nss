#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iVariable = ObtenerIntPersistente(oPC, "TIENDA_EPICA");

  if(iVariable == 1) return TRUE;
  return FALSE;
}
