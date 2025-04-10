#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iVariable = ObtenerIntPersistente(oPC, "QUEST_MUSGO_ARCHIDRUIDA");
  if(iVariable ==1 && GetItemPossessedBy(oPC, "q_bolsaoro") != OBJECT_INVALID) return TRUE;
  return FALSE;
}

