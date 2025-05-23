int StartingConditional()
{
  int iVariable = GetLocalInt(OBJECT_SELF, "ATKMENDIGO");

  if(iVariable == 2) return TRUE;
  return FALSE;
}
