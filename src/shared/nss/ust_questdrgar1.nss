int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oNotaDuergar = GetItemPossessedBy(oPC, "duergar_notaques");

  if(oNotaDuergar != OBJECT_INVALID) return TRUE;

  return FALSE;
}
