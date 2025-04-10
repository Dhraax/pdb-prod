int StartingConditional()
{
  int iStock = GetLocalInt(OBJECT_SELF, "STOCKESC");

  if(iStock <= 0) return FALSE;

  return TRUE;
}
