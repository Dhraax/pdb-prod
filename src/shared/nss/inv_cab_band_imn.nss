#include "nw_i0_tool"
int StartingConditional()
{
if(!HasItem(GetPCSpeaker(), "CabezadelBandido_Imn"))  return FALSE;
return TRUE;
}
