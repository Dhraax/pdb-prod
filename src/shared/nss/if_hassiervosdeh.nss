//::///////////////////////////////////////////////
//:: FileName if_hassiervosdeh
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 24/04/2006 13:01:28
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Comprobar si el PJ que habla tiene los objetos en su inventario
	if(!HasItem(GetPCSpeaker(), "siervosdehueso"))
		return FALSE;

	return TRUE;
}
