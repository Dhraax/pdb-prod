int StartingConditional()
{
  object oPC = GetPCSpeaker();
  string sSubraza = GetStringLowerCase(GetSubRace(oPC));

  if(sSubraza == "liche") return TRUE;
  return FALSE;
}
