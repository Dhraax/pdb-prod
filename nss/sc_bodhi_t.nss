#include "nw_i0_plot"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    string sSubRace = GetStringLowerCase(GetSubRace(oPC));

    if (sSubRace == "vampiro" || sSubRace == "engendro") return TRUE;
    if (HasItem(oPC, "mascara_nocturna")) return TRUE;

    return FALSE;
}
