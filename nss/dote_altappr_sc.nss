#include "pb_constantes"

int CanChangeWings(object oPC) {
    int nRacialType = GetRacialType(oPC);

    if (nRacialType == RACIAL_TYPE_FEYRI) return TRUE;

    return FALSE;
}

int CanChangeRace(object oPC) {
    int nRacialType = GetRacialType(oPC);

    if (nRacialType == RACIAL_TYPE_FEYRI) return TRUE;
    if (nRacialType == RACIAL_TYPE_OGROHECHICERO) return TRUE;

    return FALSE;
}

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    string sFunction = GetScriptParam("FUNCTION");

    if (sFunction == "CanChangeWings") {
        return CanChangeWings(oPC);
    }
    else if (sFunction == "CanChangeRace") {
        return CanChangeRace(oPC);
    }

    return FALSE;
}
