#include "mti_libreria"
void main()
{
    object oPC = GetPCSpeaker();
    // Dar los objetos al que habla
    CreateItemOnObject("llav_bodeg_esmel", GetPCSpeaker(), 1);
    GuardarIntPersistente(oPC, "ENANO_RATAS_ZAP_SUNE", 1);
}
