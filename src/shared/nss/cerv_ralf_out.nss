//::///////////////////////////////////////////////
//:: FileName cerv_ralf_out
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 21.04.2006 15:29:51
//:://////////////////////////////////////////////
void main()
{

	// Eliminar objetos del inventario del jugador.
	object oItemToTake;
	oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "cervezanorteair");
	if(GetIsObjectValid(oItemToTake) != 0)
		DestroyObject(oItemToTake);
}
