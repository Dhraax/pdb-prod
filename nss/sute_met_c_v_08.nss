//::///////////////////////////////////////////////
//:: FileName sute_her_c_v_08
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 07/11/2006 19:23:51
//:://////////////////////////////////////////////
void main()
{
    // Dar un poco de oro al que habla
    GiveGoldToCreature(GetPCSpeaker(), 99);


    // Eliminar objetos del inventario del jugador.
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "pepitaAdamantita");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
