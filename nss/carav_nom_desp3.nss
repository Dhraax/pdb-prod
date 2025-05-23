#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iVariable = ObtenerIntPersistente(oPC, "HABLACONTIRIS");

  if(iVariable ==1) return TRUE;
  return FALSE;
}
