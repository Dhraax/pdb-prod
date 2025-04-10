#include "mti_libreria"
void main()
{
    object oPC = GetPCSpeaker();
    GuardarIntPersistente(oPC, "NABOS_SANATORIO", 1);
    // Eliminar objetos del inventario del jugador.
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "golemfeliz");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
