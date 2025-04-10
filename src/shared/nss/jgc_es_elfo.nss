#include "lib_race"

int StartingConditional()
{
    object oPC= GetLastSpeaker();
    if(GetItemPossessedBy( oPC, "AliadodeSuldanessalar") != OBJECT_INVALID) return TRUE;
    else if(GetSubRace(oPC) == "drow" ||
       GetSubRace(oPC) == "Drow" ||
       GetSubRace(oPC) == "vampiro" ||
       GetSubRace(oPC) == "Vampiro" ||
       GetSubRace(oPC) == "ghul" ||
       GetSubRace(oPC) == "Ghul" ||
       GetSubRace(oPC) == "semidrow" ||
       GetSubRace(oPC) == "Semidrow" ||
       GetSubRace(oPC) == "deathknight" ||
       GetSubRace(oPC)  == "necropolita" ||
       GetSubRace(oPC)  == "liche" ||
       GetItemPossessedBy( oPC, "ExiliadoDeSuldanessalar") != OBJECT_INVALID
       ) return FALSE;
    else if (PB_Race_GetIsElf(oPC) || GetRacialType(oPC) == RACIAL_TYPE_HALFELF) return TRUE;
    else return FALSE;
}
