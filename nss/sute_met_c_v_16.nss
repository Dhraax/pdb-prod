//::///////////////////////////////////////////////
//:: FileName sute_her_c_v_16
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 07/11/2006 19:56:33
//:://////////////////////////////////////////////
void main()
{
    // Dar un poco de oro al que habla
    GiveGoldToCreature(GetPCSpeaker(), 990);


    // Eliminar objetos del inventario del jugador.
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "lingoteAdamantita");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
