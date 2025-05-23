int StartingConditional()
{
  int iStock = GetLocalInt(OBJECT_SELF, "STOCKCAM");

  if(iStock <= 0) return FALSE;

  return TRUE;
}
