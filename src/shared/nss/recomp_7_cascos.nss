//::///////////////////////////////////////////////
//:: FileName recomp_7_cascos
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 20/08/2005 11:14:13
//:://////////////////////////////////////////////
void main()
{

    object oPC = GetPCSpeaker();

    SetCampaignInt("quest_drow", "siete_cascos", 2, oPC);

    // Dar un poco de oro al que habla
    GiveGoldToCreature(GetPCSpeaker(), 3000);

    // Dar algunos PX al que habla
    GiveXPToCreature(GetPCSpeaker(), 2000);


    // Eliminar objetos del inventario del jugador.
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "CascoSvirfneblin_verde");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "CascoSvirfneblin_rojo");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "CascoSvirfneblin_azul");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "CascoSvirfneblin_amarillo");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "CascoSvirfneblin_marron");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "CascoSvirfneblin_violenta");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "CascoSvirfneblin_naranja");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
