#include "nw_i0_plot"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    if (HasItem(oPC, "mascara_nocturna")) return TRUE;

    return FALSE;
}
