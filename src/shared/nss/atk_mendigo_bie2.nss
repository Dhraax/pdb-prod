int StartingConditional()
{
  int iVariable = GetLocalInt(OBJECT_SELF, "ATKMENDIGO");

  if(iVariable == 1) return TRUE;
  return FALSE;
}
