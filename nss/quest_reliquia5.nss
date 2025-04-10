#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iVariable = ObtenerIntPersistente(oPC, "QUEST_RELIQUIA_SAGRADA");
  if(iVariable ==1)
    if ((GetItemPossessedBy(oPC, "ReliquiadeIdeepton") != OBJECT_INVALID) && (GetItemPossessedBy(oPC, "ReliquiadeShatar") != OBJECT_INVALID) && (GetItemPossessedBy(oPC, "ReliquiadeMinsor") != OBJECT_INVALID)) return TRUE;
  return FALSE;
}
