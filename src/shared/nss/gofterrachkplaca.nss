#include "nw_i0_tool"

int StartingConditional()
{
    if(!HasItem(GetPCSpeaker(), "gofcosaterraron"))
        return FALSE;

    return TRUE;
}
