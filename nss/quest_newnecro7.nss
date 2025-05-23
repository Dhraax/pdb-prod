#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iVariable = ObtenerIntPersistente(oPC, "QUEST_NUEVONECRO");
  int nivel1 = GetLevelByPosition(1, oPC);
  int nivel2 = GetLevelByPosition(2, oPC);
  int nivel3 = GetLevelByPosition(3, oPC);
  int total = nivel1 + nivel2 + nivel3;
  if(total<5 && iVariable==3) return TRUE;
  return FALSE;
}
