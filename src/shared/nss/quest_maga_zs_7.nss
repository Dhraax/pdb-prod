#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iVariable = ObtenerIntPersistente(oPC, "QUEST_MAGA_ZS");

  if(iVariable == 4) return TRUE;
  return FALSE;
}
