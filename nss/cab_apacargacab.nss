int StartingConditional()
{
  int iStock = GetLocalInt(OBJECT_SELF, "STOCKCAB");

  if(iStock <= 0) return FALSE;

  return TRUE;
}
