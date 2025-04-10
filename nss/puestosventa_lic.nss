#include "nw_i0_tool"

int StartingConditional()
{
  if(!HasItem(GetPCSpeaker(), "licenciagr")) return FALSE;

  return TRUE;
}
