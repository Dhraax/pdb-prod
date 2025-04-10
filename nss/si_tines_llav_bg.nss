//::///////////////////////////////////////////////
//:: FileName si_tines_llav_bg
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 01/01/2006 3:50:43
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Comprobar si el PJ que habla tiene los objetos en su inventario
	if(!HasItem(GetPCSpeaker(), "LlavedelBurdel"))
		return FALSE;

	return TRUE;
}
