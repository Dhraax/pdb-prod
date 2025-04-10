int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC) >= 4) return TRUE;
  if(GetLevelByClass(47, oPC) >= 5) return TRUE;

  return FALSE;
}
