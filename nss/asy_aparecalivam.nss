int StartingConditional()
{
  object oPC = GetPCSpeaker();
  if(GetItemPossessedBy(oPC, "asy_emblemavamp") == OBJECT_INVALID) return FALSE;

  return TRUE;
}
