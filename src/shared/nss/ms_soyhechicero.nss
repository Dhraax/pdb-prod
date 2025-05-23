int StartingConditional()
{
  if(GetLevelByClass(CLASS_TYPE_SORCERER, GetPCSpeaker()) > 0)  return TRUE;

  return FALSE;
}
