#include "nw_i0_tool"
int StartingConditional()
{
if(!HasItem(GetPCSpeaker(), "cabezaratamurann"))
    return FALSE;

return TRUE;
}
