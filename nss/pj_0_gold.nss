int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iOro = GetGold(oPC);

  if(iOro == 0) return TRUE;
  return FALSE;
}
