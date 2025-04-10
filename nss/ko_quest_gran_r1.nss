#include "mti_libreria"
void main()
{
    object oPC = GetPCSpeaker();
    // Dar algunos PX al que habla
    GiveXPToCreature(GetPCSpeaker(), 750);
    GiveGoldToCreature(GetPCSpeaker(), 10000);

    GuardarIntPersistente(oPC, "QUEST_KAZAD_GRANITO_ROJO", 1);
    // Eliminar objetos del inventario del jugador.
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "ko_granito_rojo");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
