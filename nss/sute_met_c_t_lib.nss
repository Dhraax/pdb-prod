#include "nw_i0_tool"
int StartingConditional()
{
  // Comprobar si el PJ que habla no tiene el libro de herreria
  if(HasItem(GetPCSpeaker(), "libroHerreria")) return FALSE;
  return TRUE;
}
