#include "mti_libreria"
void main()
{
    object oPC = GetPCSpeaker();
    // Dar un poco de oro al que habla
    GiveGoldToCreature(GetPCSpeaker(), 30000);

    // Dar algunos PX al que habla
    GiveXPToCreature(GetPCSpeaker(), 5000);

    GuardarIntPersistente(oPC, "PICARO_ZS_RELIQUIA", 3);
    // Eliminar objetos del inventario del jugador.
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "Reliquiafamiliar");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
