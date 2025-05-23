int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetIsDM(oPC) == TRUE || GetIsDMPossessed(oPC) == TRUE)
  {
      return TRUE;
  }
  else
  {
      if(GetTag(GetArea(oPC)) == "dm_salonesdm") return TRUE;
  }

  return FALSE;
}
