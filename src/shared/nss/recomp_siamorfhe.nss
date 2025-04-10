//::///////////////////////////////////////////////
//:: FileName recomp_siamorfhe
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 09/02/2006 17:26:23
//:://////////////////////////////////////////////
void main()
{
	// Dar un poco de oro al que habla
	GiveGoldToCreature(GetPCSpeaker(), 500);

	// Dar algunos PX al que habla
	GiveXPToCreature(GetPCSpeaker(), 200);


	// Eliminar objetos del inventario del jugador.
	object oItemToTake;
	oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "Siamorfhe");
	if(GetIsObjectValid(oItemToTake) != 0)
		DestroyObject(oItemToTake);
}
