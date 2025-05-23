#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iVariable = ObtenerIntPersistente(oPC, "FALLO_PERSUADIR_DRIADA");

  if(iVariable == 1) return FALSE;
  return TRUE;
}
