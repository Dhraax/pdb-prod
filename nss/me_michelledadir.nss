#include "mti_libreria"
void main()
{
    object oPC = GetPCSpeaker();
    GuardarIntPersistente(oPC, "LENTE_SANATORIO", 1);
    // Dar un poco de oro al que habla
    GiveGoldToCreature(GetPCSpeaker(), 5000);

    // Dar algunos PX al que habla
    GiveXPToCreature(GetPCSpeaker(), 1500);

    // Dar los objetos al que habla
    CreateItemOnObject("golemfeliz", GetPCSpeaker(), 1);


    // Eliminar objetos del inventario del jugador.
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "lenteespecial");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
