int StartingConditional()
{
  int iStock = GetLocalInt(OBJECT_SELF, "STOCKBUE");

  if(iStock <= 0) return FALSE;

  return TRUE;
}
