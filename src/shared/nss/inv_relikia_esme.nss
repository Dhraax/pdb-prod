//::///////////////////////////////////////////////
//:: FileName inv_relikia_esme
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 31.03.2006 15:20:49
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Comprobar si el PJ que habla tiene los objetos en su inventario
	if(!HasItem(GetPCSpeaker(), "Reliquiafamiliar"))
		return FALSE;

	return TRUE;
}
