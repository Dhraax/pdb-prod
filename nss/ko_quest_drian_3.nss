#include "nw_i0_tool"

int StartingConditional()
{
if((HasItem(GetPCSpeaker(), "ko_missy"))&&(HasItem(GetPCSpeaker(), "ko_missy_hijo")))
return TRUE;
return FALSE;
}
