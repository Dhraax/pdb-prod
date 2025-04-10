int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetIsDM(oPC) == TRUE || GetIsDMPossessed(oPC) == TRUE) return TRUE;

  if(GetXP(oPC) == 1000 && GetTag(GetArea(oPC)) == "BolsaPlanar") return TRUE;

  return FALSE;
}

