//::///////////////////////////////////////////////
//:: FileName posada_misnor
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 29/10/2005 23:52:24
//:://////////////////////////////////////////////
void main()
{

	// Abre la tienda con esta etiqueta o bien hace saber al usuario que no existe tienda alguna.
	object oStore = GetNearestObjectByTag("posada_misnor");
	if(GetObjectType(oStore) == OBJECT_TYPE_STORE)
		OpenStore(oStore, GetPCSpeaker());
	else
		ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}
