//::///////////////////////////////////////////////
//:: FileName kitar_decl_miake
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 21/04/2006 22:15:57
//:://////////////////////////////////////////////
void main()
{

	// Eliminar objetos del inventario del jugador.
	object oItemToTake;
	oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "Declara_mikel_esmel");
	if(GetIsObjectValid(oItemToTake) != 0)
		DestroyObject(oItemToTake);
}
