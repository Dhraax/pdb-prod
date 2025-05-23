int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetItemPossessedBy(oPC, "nedroncuerpo") == OBJECT_INVALID) return FALSE;

  return TRUE;
}
