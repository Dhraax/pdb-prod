//::///////////////////////////////////////////////
//:: FileName inv_perm_noct
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 31/05/2006 22:50:45
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Comprobar si el PJ que habla tiene los objetos en su inventario
	if(!HasItem(GetPCSpeaker(), "Permisonavalnocturno"))
		return FALSE;

	return TRUE;
}
