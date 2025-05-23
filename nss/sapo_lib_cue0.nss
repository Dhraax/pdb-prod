#include "nw_i0_tool"
int StartingConditional()
{
  // Comprobar si el PJ que habla no tiene el libro de cuero
  if(HasItem(GetPCSpeaker(), "sapocuelib")) return FALSE;
  return TRUE;
}
