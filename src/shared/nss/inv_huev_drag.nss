//::///////////////////////////////////////////////
//:: FileName inv_huev_drag
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 22/08/2005 0:42:36
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Comprobar si el PJ que habla tiene los objetos en su inventario
	if(!HasItem(GetPCSpeaker(), "HuevosdeDragn"))
		return FALSE;

	return TRUE;
}
