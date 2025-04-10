#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iVariable = ObtenerIntPersistente(oPC, "QUEST_TS");

  if(iVariable == 3) return TRUE;

  return FALSE;
}

