#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iVariableQuest = ObtenerIntPersistente(oPC, "LITHQUESTEOWO");

  if(iVariableQuest == 1 || iVariableQuest == 2) return TRUE;

  return FALSE;
}
