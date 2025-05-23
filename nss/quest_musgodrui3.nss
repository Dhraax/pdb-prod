#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iVariable = ObtenerIntPersistente(oPC, "QUEST_MUSGO_ARCHIDRUIDA");
  if(iVariable ==1) return TRUE;
  return FALSE;
}
