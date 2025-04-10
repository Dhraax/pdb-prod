int StartingConditional()
{
  object oPC = GetPCSpeaker();
  if(GetLocalInt(OBJECT_SELF, "LITHQUESTHADAFS" + GetName(oPC, TRUE)) == TRUE) return TRUE;

  return FALSE;
}
