void main()
{
     object oPC = GetPCSpeaker();
     SetCampaignInt("ghoul", "quest", 2, oPC);

    // Dar un poco de oro al que habla
    GiveGoldToCreature(GetPCSpeaker(), 2500);

    // Dar algunos PX al que habla
    GiveXPToCreature(GetPCSpeaker(), 1000);

    // Dar los objetos al que habla
    CreateItemOnObject("pieldeghoul", GetPCSpeaker(), 1);

    // Eliminar objetos del inventario del jugador.
    object oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "LgrimadellantoEterno");
    if(GetIsObjectValid(oItemToTake) != 0) DestroyObject(oItemToTake);
}
