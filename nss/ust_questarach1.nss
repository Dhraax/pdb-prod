int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if((GetGender(oPC) == GENDER_FEMALE && GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0) ||
     (GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC) > 0)) return TRUE;

  return FALSE;
}
