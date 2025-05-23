#include "nw_i0_tool"

int StartingConditional()
{
  // Comprobar si el PJ que habla tiene los objetos en su inventario
  int nLevel = GetHitDice(GetPCSpeaker());
  if((!HasItem(GetPCSpeaker(), "esencianishruu")) || (nLevel < 11)) return FALSE;
  return TRUE;
}
