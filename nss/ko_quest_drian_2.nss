#include "nw_i0_tool"

int StartingConditional()
{
if(!HasItem(GetPCSpeaker(), "ko_missy"))
return FALSE;
return TRUE;
}
