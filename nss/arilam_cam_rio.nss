#include "nw_i0_tool"
int StartingConditional()
{
  if(!HasItem(GetPCSpeaker(), "Instrucciones_avanzadilla"))  return FALSE;
  return TRUE;
}
