//::///////////////////////////////////////////////
//:: FileName compruebacenti
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 11/06/2010 16:24:23
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Comprobar si el PJ que habla tiene los objetos en su inventario
	if(!HasItem(GetPCSpeaker(), "cuerno_centinelas"))
		return FALSE;

	return TRUE;
}
