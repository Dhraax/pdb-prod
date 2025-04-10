int StartingConditional()
{
  if(GetLevelByClass(CLASS_TYPE_SHIFTER, GetPCSpeaker()) >= 8) return TRUE;

  return FALSE;
}
