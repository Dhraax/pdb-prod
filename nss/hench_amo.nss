int StartingConditional()
{
  if(GetMaster(OBJECT_SELF) == GetPCSpeaker()) return TRUE;

  return FALSE;
}
