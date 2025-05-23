int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetHasFeat(1280, oPC) == TRUE) return TRUE;

  return FALSE;
}
