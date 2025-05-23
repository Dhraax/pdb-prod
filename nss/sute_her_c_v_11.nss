//::///////////////////////////////////////////////
//:: FileName sute_her_c_v_11
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 07/11/2006 19:54:20
//:://////////////////////////////////////////////
void main()
{
    // Dar un poco de oro al que habla
    GiveGoldToCreature(GetPCSpeaker(), 24);


    // Eliminar objetos del inventario del jugador.
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "pastaTerrosa");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
