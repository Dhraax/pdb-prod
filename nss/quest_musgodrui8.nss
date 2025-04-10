#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iVariable = ObtenerIntPersistente(oPC, "QUEST_MUSGO_ARCHIDRUIDA");
  if(iVariable ==4 && GetItemPossessedBy(oPC, "q_cabezatroll") != OBJECT_INVALID ) return TRUE;
  return FALSE;
}
