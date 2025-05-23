int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetHasFeat(1273, oPC) == TRUE) return TRUE;

  return FALSE;
}
