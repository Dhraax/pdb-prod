//::///////////////////////////////////////////////
//:: FileName recomp_huevos_dr
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 22/08/2005 0:46:06
//:://////////////////////////////////////////////
#include "nw_i0_tool"

void main()
{

    object oPC = GetPCSpeaker();

    SetCampaignInt("quest_huevos", "verfare", 2, oPC);

    // Dar un poco de oro al que habla
    GiveGoldToCreature(GetPCSpeaker(), 3000);

    // Dar algunos PX al que habla
    RewardPartyXP(1500, GetPCSpeaker(), FALSE);


    // Eliminar objetos del inventario del jugador.
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "HuevosdeDragn");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
