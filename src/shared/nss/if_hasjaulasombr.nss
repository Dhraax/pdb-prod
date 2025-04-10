//::///////////////////////////////////////////////
//:: FileName if_hasjaulasombr
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 23/04/2006 15:18:37
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Comprobar si el PJ que habla tiene los objetos en su inventario
	if(!HasItem(GetPCSpeaker(), "jaulasombria"))
		return FALSE;

	return TRUE;
}
