#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iVariable = ObtenerIntPersistente(oPC, "quest_viuda");

  if(iVariable == 2) return TRUE;
  return FALSE;
}
