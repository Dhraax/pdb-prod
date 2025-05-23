int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iOro = GetGold(oPC);

  if(iOro >= 100000) return TRUE;
  return FALSE;
}
