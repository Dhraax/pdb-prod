//::///////////////////////////////////////////////
//:: FileName inv_cab_mulahey
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 25/09/2005 4:08:56
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Comprobar si el PJ que habla tiene los objetos en su inventario
	if(!HasItem(GetPCSpeaker(), "CabezadeMulahey"))
		return FALSE;

	return TRUE;
}
