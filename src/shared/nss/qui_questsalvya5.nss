#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iVariableQuest = ObtenerIntPersistente(oPC, "LITHQUESTSALVYA");

  if(iVariableQuest > 0) return FALSE;

  return TRUE;
}
