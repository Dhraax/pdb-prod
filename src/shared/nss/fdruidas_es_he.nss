#include "lib_race"

int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetLevelByClass(CLASS_TYPE_SHIFTER, oPC) >= 7) return TRUE;

  if(PB_Race_GetIsElf(oPC) ||
     GetAppearanceType(oPC) == 1) return TRUE;

  if(GetRacialType(oPC) == RACIAL_TYPE_HALFELF ||
     GetAppearanceType(oPC) == 4) return TRUE;

  if(GetRacialType(oPC) == RACIAL_TYPE_HUMAN ||
     GetAppearanceType(oPC) == 6) return TRUE;

  return FALSE;
}
