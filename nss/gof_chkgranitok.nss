#include "nw_i0_tool"

int StartingConditional()
{
    if(!HasItem(GetPCSpeaker(), "gof_sacomolido"))
        return FALSE;
    return TRUE;
}
