#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iVariableQuest = ObtenerIntPersistente(oPC, "LITHQUESTEOWO");

  if(iVariableQuest > 0) return FALSE;

  return TRUE;
}
