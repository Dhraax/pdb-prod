#include "nw_i0_tool"

int StartingConditional()
{

object oPC = GetPCSpeaker();

// Comprobar si el PJ tiene la cabeza de jabali
if(!HasItem(oPC, "CabezadelJefeJabal")) return FALSE;

return TRUE;
}
