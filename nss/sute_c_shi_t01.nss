int StartingConditional()
{
  if(GetLevelByClass(CLASS_TYPE_SHIFTER, GetPCSpeaker()) >= 1) return TRUE;

  return FALSE;
}
