#include "lib_race"

int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetLevelByClass(CLASS_TYPE_SHIFTER, oPC) >= 7) return TRUE;

  if(GetRacialType(oPC) == RACIAL_TYPE_DWARF ||
     GetAppearanceType(oPC) == 0) return TRUE;

  if(GetRacialType(oPC) == RACIAL_TYPE_GNOME ||
     GetAppearanceType(oPC) == 2) return TRUE;

  if(PB_Race_GetIsHalfling(oPC) ||
     GetAppearanceType(oPC) == 3) return TRUE;

  string sSubraza = GetStringLowerCase(GetSubRace(oPC));
  if(sSubraza == "trasgo" || sSubraza == "kobold") return TRUE;

  return FALSE;
}
