#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iVariable = ObtenerIntPersistente(oPC, "CARTA_SECR_ESMEL");

  if(iVariable <= 1) return TRUE;
  return FALSE;
}
