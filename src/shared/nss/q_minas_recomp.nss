//::///////////////////////////////////////////////
//:: FileName q_minas_recomp
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 25/09/2005 4:10:20
//:://////////////////////////////////////////////
void main()
{
     object oPC = GetPCSpeaker();

     SetCampaignInt("quest", "minas naskel", 2, oPC);

    // Dar un poco de oro al que habla
    GiveGoldToCreature(GetPCSpeaker(), 15000);

    // Dar algunos PX al que habla
    GiveXPToCreature(GetPCSpeaker(), 3000);


    // Eliminar objetos del inventario del jugador.
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "CabezadeMulahey");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
