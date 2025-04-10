int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetGold(oPC) >= 1500) return TRUE;
  return FALSE;
}
