//::///////////////////////////////////////////////
//:: FileName sute_her_c_t_02
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 07/11/2006 19:15:15
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Comprobar si el PJ que habla tiene los objetos en su inventario
	if(!HasItem(GetPCSpeaker(), "brisaSusurrante"))
		return FALSE;

	return TRUE;
}
