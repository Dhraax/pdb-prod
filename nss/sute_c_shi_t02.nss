int StartingConditional()
{
  if(GetLevelByClass(CLASS_TYPE_SHIFTER, GetPCSpeaker()) >= 2) return TRUE;

  return FALSE;
}
