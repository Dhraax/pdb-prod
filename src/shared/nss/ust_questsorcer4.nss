int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetItemPossessedBy(oPC, "Thormmallem") == OBJECT_INVALID) return FALSE;

  return TRUE;
}
