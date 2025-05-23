//::///////////////////////////////////////////////
//:: FileName inv_cerv_ralf
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 21.04.2006 15:29:03
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Comprobar si el PJ que habla tiene los objetos en su inventario
	if(!HasItem(GetPCSpeaker(), "cervezanorteair"))
		return FALSE;

	return TRUE;
}
