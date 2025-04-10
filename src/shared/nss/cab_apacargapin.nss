int StartingConditional()
{
  int iStock = GetLocalInt(OBJECT_SELF, "STOCKPIN");

  if(iStock <= 0) return FALSE;

  return TRUE;
}
