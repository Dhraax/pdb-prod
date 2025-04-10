int StartingConditional()
{
  object oMod = GetModule();
  int iVariable = GetLocalInt(oMod, "ATK_BURDELMUJER");

  if(iVariable == 1) return TRUE;
  return FALSE;
}
