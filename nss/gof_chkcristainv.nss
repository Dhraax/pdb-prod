#include "nw_i0_tool"

int StartingConditional()
{
    if(!HasItem(GetPCSpeaker(), "qui_coponieve"))
        return FALSE;

    return TRUE;
}
