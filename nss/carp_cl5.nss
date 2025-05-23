#include "nw_i0_tool"
int StartingConditional()
{
  // Comprobar si el PJ que habla tiene los objetos en su inventario
  if(!HasItem(GetPCSpeaker(), "carplenyo_alamo")) return FALSE;
  return TRUE;
}
