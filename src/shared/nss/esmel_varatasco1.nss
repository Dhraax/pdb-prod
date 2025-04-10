int StartingConditional()
{
  object oReja = GetNearestObjectByTag("rejavariable1");
  string sVariable = GetLocalString(oReja, "Atascado");

  if(sVariable == "1") return TRUE;
  return FALSE;
}
