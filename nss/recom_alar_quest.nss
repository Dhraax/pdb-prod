#include "mti_libreria"
void main()
{
    object oPC = GetPCSpeaker();
    // Dar algunos PX al que habla
    GiveXPToCreature(GetPCSpeaker(), 3000);

    // Dar los objetos al que habla
    CreateItemOnObject("viejallaveo_esme", GetPCSpeaker(), 1);

    GuardarIntPersistente(oPC, "QUEST_ALARICO_ESMEL", 2);
    // Eliminar objetos del inventario del jugador.
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "herr_trabj_alar_quest");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
