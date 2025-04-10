int StartingConditional()
{
  object oPC = GetPCSpeaker();
  if(GetItemPossessedBy(oPC, "qui_coponieve") != OBJECT_INVALID) return TRUE;

  return FALSE;
}
