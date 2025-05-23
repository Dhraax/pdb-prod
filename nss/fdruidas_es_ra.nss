int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetLevelByClass(CLASS_TYPE_SHIFTER, oPC) >= 7) return TRUE;

  if(GetRacialType(oPC) == RACIAL_TYPE_HALFORC ||
     GetAppearanceType(oPC) == 5) return TRUE;

  if(GetRacialType(oPC) == RACIAL_TYPE_HUMANOID_GOBLINOID &&
     GetStringLowerCase(GetSubRace(oPC)) != "trasgo") return TRUE;

  if(GetRacialType(oPC) == RACIAL_TYPE_HUMANOID_MONSTROUS) return TRUE;

  if(GetRacialType(oPC) == RACIAL_TYPE_HUMANOID_ORC) return TRUE;

  if(GetRacialType(oPC) == RACIAL_TYPE_GIANT) return TRUE;

  return FALSE;
}
