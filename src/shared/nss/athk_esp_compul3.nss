#include "mti_libreria"
void main()
{
    object oPC = GetPCSpeaker();
    // Dar algunos PX y oro al que habla
    GiveXPToCreature(GetPCSpeaker(), 1000);
    GiveGoldToCreature(GetPCSpeaker(), 3000);

    GuardarIntPersistente(oPC, "ESPOSA_COMPULGIDA", 2);
    // Eliminar objetos del inventario del jugador.
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "Alian_Eldur");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
    AdjustAlignment(oPC,ALIGNMENT_GOOD,2);
}

