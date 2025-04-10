int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iOro = GetGold(oPC);

  if(iOro >= 10000) return TRUE;
  return FALSE;
}
