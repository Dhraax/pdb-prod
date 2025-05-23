#include "nw_i0_plot"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    if (HasItem(oPC, "runa_retorcida")) return TRUE;

    return FALSE;
}
