int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetDeity(oPC) == "" &&
    (GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oPC) > 0 ||
     GetLevelByClass(CLASS_TYPE_BARD, oPC) > 0 ||
     GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC) > 0 ||
     GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0 ||
     GetLevelByClass(CLASS_TYPE_DIVINE_CHAMPION, oPC) > 0 ||
     GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE, oPC) > 0 ||
     GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0 ||
     GetLevelByClass(CLASS_TYPE_HARPER, oPC) > 0 ||
     GetLevelByClass(CLASS_TYPE_MONK, oPC) > 0 ||
     GetLevelByClass(CLASS_TYPE_PALADIN, oPC) > 0 ||
     GetLevelByClass(CLASS_TYPE_PALE_MASTER, oPC) > 0 ||
     GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 0 ||
     GetLevelByClass(CLASS_TYPE_SHIFTER, oPC) > 0 ||
     GetLevelByClass(CLASS_TYPE_SORCERER, oPC) > 0 ||
     GetLevelByClass(CLASS_TYPE_WIZARD, oPC) > 0))  return TRUE;

  return FALSE;
}
