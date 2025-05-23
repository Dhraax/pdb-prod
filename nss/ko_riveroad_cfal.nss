#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iVariable = ObtenerIntPersistente(oPC, "FALLO_ABRIR_TIENDA_ENANOCAMRIO");

  if(iVariable == 1) return TRUE;
  return FALSE;
}
