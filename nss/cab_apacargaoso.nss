int StartingConditional()
{
  int iStock = GetLocalInt(OBJECT_SELF, "STOCKOSO");

  if(iStock <= 0) return FALSE;

  return TRUE;
}
