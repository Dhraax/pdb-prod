int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetItemPossessedBy(oPC, "uri_ojooso") == OBJECT_INVALID) return FALSE;

  return TRUE;
}
