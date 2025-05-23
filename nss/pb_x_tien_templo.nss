//::///////////////////////////////////////////////
//:: FileName pb_x_tien_templo
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 29/07/2005 20:51:08
//:://////////////////////////////////////////////
void main()
{

	// Abre la tienda con esta etiqueta o bien hace saber al usuario que no existe tienda alguna.
	object oStore = GetNearestObjectByTag("NW_STORETMPLE001");
	if(GetObjectType(oStore) == OBJECT_TYPE_STORE)
		OpenStore(oStore, GetPCSpeaker());
	else
		ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}
