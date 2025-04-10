int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oPoder = GetItemPossessedBy(oPC, "quest_ts_poder");

  if(oPoder != OBJECT_INVALID) return TRUE;

  return FALSE;
}
