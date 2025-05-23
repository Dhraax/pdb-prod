#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iVariable = ObtenerIntPersistente(oPC, "DESEO_AVENTURA");

  if(iVariable == 2) return TRUE;
  return FALSE;
}
