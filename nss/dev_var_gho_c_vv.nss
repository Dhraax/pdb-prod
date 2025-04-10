int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iVariable = GetLocalInt(oPC, "GHOUL_CIRIPT_VV");

  if(iVariable == 1) return TRUE;
  return FALSE;
}
