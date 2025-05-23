#include "nw_i0_tool"

int StartingConditional()
{
    if(!HasItem(GetPCSpeaker(), "cabalanigros"))
        return FALSE;

    return TRUE;
}
