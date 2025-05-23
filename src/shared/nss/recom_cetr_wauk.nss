#include "mti_libreria"
void main()
{
    // Dar un poco de oro al que habla
    GiveGoldToCreature(GetPCSpeaker(), 20000);

    // Dar algunos PX al que habla
    GiveXPToCreature(GetPCSpeaker(), 5000);

    // Dar los objetos al que habla
    CreateItemOnObject("mon_sag_waueekn", GetPCSpeaker(), 1);
    CreateItemOnObject("mon_sag_waueekn", GetPCSpeaker(), 1);
    CreateItemOnObject("mon_sag_waueekn", GetPCSpeaker(), 1);
    CreateItemOnObject("mon_sag_waueekn", GetPCSpeaker(), 1);

    object oPC = GetPCSpeaker();
    GuardarIntPersistente(oPC, "AVISO_CEMENTERIO", 3);


    // Eliminar objetos del inventario del jugador.
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "CetrodeWaukin");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
