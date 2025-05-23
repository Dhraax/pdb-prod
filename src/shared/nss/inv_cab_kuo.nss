#include "nw_i0_tool"
int StartingConditional()
{
if(!HasItem(GetPCSpeaker(), "cabezakuotoa"))
    return FALSE;

return TRUE;
}
