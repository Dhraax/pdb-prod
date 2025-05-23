//::///////////////////////////////////////////////
//:: FileName sute_her_c_v_07
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 07/11/2006 19:23:24
//:://////////////////////////////////////////////
void main()
{
	// Dar un poco de oro al que habla
	GiveGoldToCreature(GetPCSpeaker(), 32);


	// Eliminar objetos del inventario del jugador.
	object oItemToTake;
	oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "setaNocturna");
	if(GetIsObjectValid(oItemToTake) != 0)
		DestroyObject(oItemToTake);
}
