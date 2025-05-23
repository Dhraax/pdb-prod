int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iOro = GetGold(oPC);

  if(iOro >= 12000) return TRUE;
  return FALSE;
}
