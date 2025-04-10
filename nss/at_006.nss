//::///////////////////////////////////////////////
//:: FileName at_006
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 22/03/2011 1:25:42
//:://////////////////////////////////////////////
#include "nw_i0_plot"

void main()
{

	// Abre la tienda con esta etiqueta o bien hace saber al usuario que no existe tienda alguna.
	object oStore = GetNearestObjectByTag("paz_capas");
	if(GetObjectType(oStore) == OBJECT_TYPE_STORE)
		gplotAppraiseOpenStore(oStore, GetPCSpeaker());
	else
		ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}
