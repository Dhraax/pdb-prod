int StartingConditional()
{
  int iStock = GetLocalInt(OBJECT_SELF, "STOCKJAB");

  if(iStock <= 0) return FALSE;

  return TRUE;
}
