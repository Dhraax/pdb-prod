#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iVariable = ObtenerIntPersistente(oPC, "QUEST_NUEVONECRO");
  if(!(iVariable ==6)) return FALSE;
  return TRUE;
}
