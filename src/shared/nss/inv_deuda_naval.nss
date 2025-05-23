//::///////////////////////////////////////////////
//:: FileName inv_deuda_naval
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 13.06.2006 14:15:17
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Comprobar si el PJ que habla tiene los objetos en su inventario
	if(!HasItem(GetPCSpeaker(), "DeudaNaval"))
		return FALSE;

	return TRUE;
}
