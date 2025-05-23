int StartingConditional()
{
  if(!(GetLocalInt(OBJECT_SELF, "sacrificio") == 1)) return FALSE;

  return TRUE;
}
