#include "nw_i0_tool"
int StartingConditional()
{
  // Comprobar si el PJ que habla tiene los objetos en su inventario
  if(!HasItem(GetPCSpeaker(), "bru_dia")) return FALSE;
  return TRUE;
}
