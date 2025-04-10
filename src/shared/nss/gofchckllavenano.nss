//::///////////////////////////////////////////////
//:: FileName gofchckllavenano
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 21/05/2011 16:08:26
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

	// Make sure the PC speaker has these items in their inventory
	if(!HasItem(GetPCSpeaker(), "jj_llaveenanos"))
		return FALSE;

	return TRUE;
}
