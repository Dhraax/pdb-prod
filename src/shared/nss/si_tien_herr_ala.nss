//::///////////////////////////////////////////////
//:: FileName si_tien_herr_ala
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 01/02/2006 14:57:33
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Comprobar si el PJ que habla tiene los objetos en su inventario
	if(!HasItem(GetPCSpeaker(), "herr_trabj_alar_quest"))
		return FALSE;

	return TRUE;
}
