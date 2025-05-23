#include "nw_i0_tool"
int StartingConditional()
{
// Comprobar si el PJ que habla tiene los objetos en su inventario
if(!HasItem(GetPCSpeaker(), "X0_IT_MTHNMISC13")) return FALSE;
return TRUE;
}
