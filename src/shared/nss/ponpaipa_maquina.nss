int StartingConditional()
{
  object oPalanca = GetNearestObjectByTag("palanca_antimagia");
  int iVariable = GetLocalInt(oPalanca, "AMNAGANTIMAGIA");

  if(iVariable > 10) return TRUE;

  return FALSE;
}
