int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetHasFeat(1274, oPC) == TRUE) return TRUE;

  return FALSE;
}
