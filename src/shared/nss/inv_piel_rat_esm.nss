//::///////////////////////////////////////////////
//:: FileName inv_piel_rat_esm
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 23/01/2006 14:16:07
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Comprobar si el PJ que habla tiene los objetos en su inventario
	if(!HasItem(GetPCSpeaker(), "pell_rat_bod_esmel"))
		return FALSE;

	return TRUE;
}
