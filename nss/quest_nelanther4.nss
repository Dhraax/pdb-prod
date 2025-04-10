#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iVariable = ObtenerIntPersistente(oPC, "QUEST_IRPHONG");

  if(iVariable ==2) return TRUE;
  return FALSE;
}
