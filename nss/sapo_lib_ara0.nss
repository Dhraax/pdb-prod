#include "nw_i0_tool"
int StartingConditional()
{
  // Comprobar si el PJ que habla no tiene el libro de artesania arcana
  if(HasItem(GetPCSpeaker(), "pb_ofi_man_artes")) return FALSE;
  return TRUE;
}
