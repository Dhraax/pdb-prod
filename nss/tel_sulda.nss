#include "mti_libreria"
#include "lib_race"

int StartingConditional()
{
    object oPC= GetPCSpeaker();
    string sSubraza = GetStringLowerCase(GetSubRace(oPC));
    int iClase1 = GetClassByPosition(1, oPC);
    int iClase2 = GetClassByPosition(2, oPC);
    int iClase3 = GetClassByPosition(3, oPC);
    int nLevel = GetLevelByPosition(1, oPC) + GetLevelByPosition(2, oPC)+ GetLevelByPosition(3, oPC);

    if(GetStringLowerCase(GetSubRace(oPC)) == "drow" ||
       GetStringLowerCase(GetSubRace(oPC)) == "vampiro" ||
       GetStringLowerCase(GetSubRace(oPC)) == "ghul" ||
       GetStringLowerCase(GetSubRace(oPC)) == "semidrow" ||
       GetStringLowerCase(GetSubRace(oPC)) == "deathknight" ||
       GetStringLowerCase(GetSubRace(oPC))  == "necropolita" ||
       GetStringLowerCase(GetSubRace(oPC))  == "liche" ||
       GetItemPossessedBy( oPC, "ExiliadoDeSuldanessalar") != OBJECT_INVALID
       ) return FALSE;
    else if (PB_Race_GetIsElf(oPC) || GetRacialType(oPC) == RACIAL_TYPE_HALFELF || sSubraza=="lythari" || sSubraza=="semifata") return TRUE;
    else if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
         {
            if (ObtenerIntPersistente(oPC, "TEL_SULDA") == TRUE)
            {
                if (nLevel>=8) return TRUE;
            }
         }
    else if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_NEUTRAL ||
            GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD
            )
            {
               if (ObtenerIntPersistente(oPC, "TEL_SULDA") == TRUE) return TRUE;
            }

    else return FALSE;
    return FALSE;
}
