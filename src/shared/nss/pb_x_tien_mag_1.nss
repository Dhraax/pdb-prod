//::///////////////////////////////////////////////
//:: FileName pb_x_tien_mag_1
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 03/08/2005 15:13:54
//:://////////////////////////////////////////////
void main()
{

	// Abre la tienda con esta etiqueta o bien hace saber al usuario que no existe tienda alguna.
	object oStore = GetNearestObjectByTag("NW_STOREMAGIC001");
	if(GetObjectType(oStore) == OBJECT_TYPE_STORE)
		OpenStore(oStore, GetPCSpeaker());
	else
		ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}
