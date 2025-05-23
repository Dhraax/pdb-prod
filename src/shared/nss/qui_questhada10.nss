int StartingConditional()
{
  object oPC = GetPCSpeaker();
  if(GetItemPossessedBy(oPC, "NW_IT_MSMLMISC19") != OBJECT_INVALID) return TRUE;

  return FALSE;
}
