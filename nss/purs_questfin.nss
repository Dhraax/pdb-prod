int StartingConditional()
{
  if(GetItemPossessedBy(GetPCSpeaker(), "purskulselloroto") == OBJECT_INVALID) return FALSE;
  return TRUE;
}
