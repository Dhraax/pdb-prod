//::///////////////////////////////////////////////
//:: FileName gof_chkcostillar
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 02/06/2011 21:24:22
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Make sure the PC speaker has these items in their inventory
	if(!HasItem(GetPCSpeaker(), "chuletonterraron"))
		return FALSE;

	return TRUE;
}
