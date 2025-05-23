#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iVariable = ObtenerIntPersistente(oPC, "quest_selune");

  if(iVariable == 1) return TRUE;
  return FALSE;
}
