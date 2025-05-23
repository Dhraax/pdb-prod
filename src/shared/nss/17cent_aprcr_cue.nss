int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetItemPossessedBy(oPC, "cuerno_centinelas") == OBJECT_INVALID) return FALSE;
  return TRUE;
}

