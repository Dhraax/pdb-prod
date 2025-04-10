#include "nw_i0_plot"
#include "pb_constantes"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nRacialType = GetRacialType(oPC);
    string sSubRace = GetStringLowerCase(GetSubRace(oPC));

    if (nRacialType == RACIAL_TYPE_WIGHT || sSubRace == "liche") return TRUE;
    if (HasItem(oPC, "runa_retorcida")) return TRUE;

    return FALSE;
}
