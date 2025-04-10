int StartingConditional()
{
  if(GetLevelByClass(CLASS_TYPE_SHIFTER, GetPCSpeaker()) >= 4) return TRUE;

  return FALSE;
}
