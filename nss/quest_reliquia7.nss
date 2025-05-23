#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iVariable = ObtenerIntPersistente(oPC, "QUEST_RELIQUIA_SAGRADA");
  if(iVariable ==2) return TRUE;
  return FALSE;
}
