#include "nw_i0_tool"
int StartingConditional()
{
  if(!HasItem(GetPCSpeaker(), "Taladro")) return FALSE;
  return TRUE;
}
