int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oCabezaDuergar = GetItemPossessedBy(oPC, "cabezadliderduer");

  if(oCabezaDuergar != OBJECT_INVALID) return TRUE;

  return FALSE;
}
