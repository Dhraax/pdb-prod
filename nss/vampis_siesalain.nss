int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oVarita = GetItemPossessedBy(oPC, "VaritaPJ");

  if(oVarita != OBJECT_INVALID) return TRUE;
  return FALSE;
}
