#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iVariable = ObtenerIntPersistente(oPC, "DESPELLEJADOR_CARAVASSAR");

  if(iVariable ==3) return TRUE;
  return FALSE;
}
