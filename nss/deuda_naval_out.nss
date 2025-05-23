//::///////////////////////////////////////////////
//:: FileName deuda_naval_out
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 13.06.2006 15:07:37
//:://////////////////////////////////////////////
void main()
{

	// Quitar algo de oro al jugador
	TakeGoldFromCreature(2000, GetPCSpeaker(), TRUE);

	// Eliminar objetos del inventario del jugador.
	object oItemToTake;
	oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "DeudaNaval");
	if(GetIsObjectValid(oItemToTake) != 0)
		DestroyObject(oItemToTake);
}
