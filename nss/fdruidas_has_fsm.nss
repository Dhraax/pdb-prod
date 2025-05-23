int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetHasFeat(1271, oPC) == TRUE) return TRUE;

  return FALSE;
}
