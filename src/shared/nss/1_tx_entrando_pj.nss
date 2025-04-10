int StartingConditional()
{
  object oPC = GetPCSpeaker();
  string sSubraza = GetStringLowerCase(GetSubRace(oPC));

  if(sSubraza == "ghul") return TRUE;
  return FALSE;
}
