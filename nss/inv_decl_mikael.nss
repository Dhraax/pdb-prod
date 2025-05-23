//::///////////////////////////////////////////////
//:: FileName inv_decl_mikael
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 21.04.2006 15:25:02
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Comprobar si el PJ que habla tiene los objetos en su inventario
	if(!HasItem(GetPCSpeaker(), "Declara_mikel_esmel"))
		return FALSE;

	return TRUE;
}
