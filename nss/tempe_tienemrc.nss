//::///////////////////////////////////////////////
//:: FileName tempe_tienemrc
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 22/07/2016 20:17:08
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Comprobar si el PJ que habla tiene los objetos en su inventario
	if(!HasItem(GetPCSpeaker(), "monedaconrec"))
		return FALSE;

	return TRUE;
}
