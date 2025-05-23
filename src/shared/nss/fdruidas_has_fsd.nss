int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetHasFeat(1272, oPC) == TRUE) return TRUE;

  return FALSE;
}
