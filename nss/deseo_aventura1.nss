#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oPergamino = GetItemPossessedBy(oPC, "pergaminodelcrom");
  int iVariable = ObtenerIntPersistente(oPC, "DESEO_AVENTURA");

  if(oPergamino != OBJECT_INVALID && iVariable == 1) return TRUE;
  return FALSE;
}
