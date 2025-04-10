int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetLocalInt(oPC, "QUESTMISNOR") == 1) return TRUE;

  return FALSE;
}
