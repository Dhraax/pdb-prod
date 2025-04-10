#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iQuestDuergar = ObtenerIntPersistente(oPC, "UST_QDUERGAR");

  if(iQuestDuergar == 1) return TRUE;

  return FALSE;
}
