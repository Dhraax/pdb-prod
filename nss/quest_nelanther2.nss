#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iVariable = ObtenerIntPersistente(oPC, "QUEST_IRPHONG");

  if(iVariable ==1) return TRUE;
  return FALSE;
}
