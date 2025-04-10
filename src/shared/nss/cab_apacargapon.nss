int StartingConditional()
{
  int iStock = GetLocalInt(OBJECT_SELF, "STOCKPON");

  if(iStock <= 0) return FALSE;

  return TRUE;
}
