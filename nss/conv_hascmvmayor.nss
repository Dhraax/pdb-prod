int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC) >= 9) return TRUE;
  if(GetLevelByClass(47, oPC) >= 9) return TRUE;

  return FALSE;
}
