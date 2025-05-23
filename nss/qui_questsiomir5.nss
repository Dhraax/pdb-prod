#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iVariableQuest = ObtenerIntPersistente(oPC, "LITHQUESTSIOMIR");

  if(iVariableQuest == 2) return TRUE;

  return FALSE;
}
