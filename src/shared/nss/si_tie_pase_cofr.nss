#include "nw_i0_tool"
int StartingConditional()
{
  if(!HasItem(GetPCSpeaker(), "pasedelacofradia")) return FALSE;
  return TRUE;
}
