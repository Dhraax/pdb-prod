int StartingConditional()
{
  int iStock = GetLocalInt(OBJECT_SELF, "STOCKTEJ");

  if(iStock <= 0) return FALSE;

  return TRUE;
}
