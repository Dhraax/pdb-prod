#include "nw_i0_tool"
int StartingConditional()
{
  // Comprobar si el PJ que habla tiene los objetos en su inventario
  if(!HasItem(GetPCSpeaker(), "carptablon_cedro")) return FALSE;
  return TRUE;
}
