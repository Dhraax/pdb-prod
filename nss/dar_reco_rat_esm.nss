#include "mti_libreria"
void main()
{
    object oPC = GetPCSpeaker();
    // Dar un poco de oro al que habla
    GiveGoldToCreature(GetPCSpeaker(), 2000);

    // Dar algunos PX al que habla
    GiveXPToCreature(GetPCSpeaker(), 2000);

    // Dar los objetos al que habla
    CreateItemOnObject("llav_ba_cl_esm_z", GetPCSpeaker(), 1);

    GuardarIntPersistente(oPC, "ENANO_RATAS_ZAP_SUNE", 2);
    // Eliminar objetos del inventario del jugador.
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "pell_rat_bod_esmel");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);

}
