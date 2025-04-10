int StartingConditional()
{
  if(GetLevelByClass(CLASS_TYPE_SHIFTER, GetPCSpeaker()) >= 6) return TRUE;

  return FALSE;
}
