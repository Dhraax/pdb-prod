#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iVariableQuest = ObtenerIntPersistente(oPC, "LITHQUESTHADA");

  if(iVariableQuest == 2) return TRUE;

  return FALSE;
}
