#include "mti_libreria"
#include "lib_race"

int StartingConditional()
{
    object oPC= GetLastSpeaker();
    string sSubraza = GetStringLowerCase(GetSubRace(oPC));
    int iClase1 = GetClassByPosition(1, oPC);
    int iClase2 = GetClassByPosition(2, oPC);
    int iClase3 = GetClassByPosition(3, oPC);

    if(GetItemPossessedBy( oPC, "AliadodeSuldanessalar") != OBJECT_INVALID) return TRUE;
    else if(GetStringLowerCase(GetSubRace(oPC)) == "drow" ||
       GetStringLowerCase(GetSubRace(oPC)) == "vampiro" ||
       GetStringLowerCase(GetSubRace(oPC)) == "ghul" ||
       GetStringLowerCase(GetSubRace(oPC)) == "semidrow" ||
       GetStringLowerCase(GetSubRace(oPC)) == "deathknight" ||
       GetStringLowerCase(GetSubRace(oPC))  == "necropolita" ||
       GetStringLowerCase(GetSubRace(oPC))  == "liche" ||
       GetItemPossessedBy( oPC, "ExiliadoDeSuldanessalar") != OBJECT_INVALID
       ) return FALSE;
    else if(PB_Race_GetIsElf(oPC) ||
       GetRacialType(oPC) == RACIAL_TYPE_HALFELF ||
       sSubraza=="lythari" ||
       sSubraza=="semifata" ||
       iClase1==CLASS_TYPE_DRUID  || iClase1==CLASS_TYPE_RANGER ||
       iClase2==CLASS_TYPE_DRUID  || iClase2==CLASS_TYPE_RANGER||
       iClase3==CLASS_TYPE_DRUID  || iClase3==CLASS_TYPE_RANGER
       )
     return TRUE;
     else return FALSE;
}
