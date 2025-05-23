//::///////////////////////////////////////////////
//:: FileName sute_her_c_v_06
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 07/11/2006 19:23:04
//:://////////////////////////////////////////////
void main()
{
    // Dar un poco de oro al que habla
    GiveGoldToCreature(GetPCSpeaker(), 34);


    // Eliminar objetos del inventario del jugador.
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "pepitaOro");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
