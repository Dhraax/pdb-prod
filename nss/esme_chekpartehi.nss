//::///////////////////////////////////////////////
//:: FileName esme_chekpartehi
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 26/01/2006 21:51:23
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Comprobar si el PJ que habla tiene los objetos en su inventario
	if(!HasItem(GetPCSpeaker(), "partehierros"))
		return FALSE;

	return TRUE;
}
