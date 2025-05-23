#include "nw_i0_tool"
int StartingConditional()
{
  // Comprobar si el PJ que habla no tiene el libro de carpinteria
  if(HasItem(GetPCSpeaker(), "orf_libro")) return FALSE;
  return TRUE;
}
