#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iVariable = ObtenerIntPersistente(oPC, "QUEST_MUSGO_ARCHIDRUIDA");
  if(iVariable ==2 && GetItemPossessedBy(oPC, "q_semidruida") != OBJECT_INVALID ) return TRUE;
  return FALSE;
}
