#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oPoder = GetItemPossessedBy(oPC, "quest_ts_poder");

  if(oPoder == OBJECT_INVALID) return TRUE;

  DestroyObject(oPoder);
  AdjustAlignment(oPC, ALIGNMENT_EVIL, 5, FALSE);
  CreateItemOnObject("quest_ts_capa", oPC);
  GuardarIntPersistente(oPC, "QUEST_TS", 4);
  SetXP(oPC, GetXP(oPC) + 2000);
  return FALSE;
}
