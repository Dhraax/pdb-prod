#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(ObtenerIntPersistente(oPC, "QUESTRIBALD") == 1) return FALSE;
  if(GetSkillRank(3, oPC) < 5) return FALSE;

  return TRUE;
}
