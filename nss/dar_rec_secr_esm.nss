#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();
GuardarIntPersistente(oPC, "CARTA_SECR_ESMEL", 1);

// Dar los objetos al que habla
CreateItemOnObject("carta_uni_athkat", GetPCSpeaker(), 1);
CreateItemOnObject("mon_plat_esmel", GetPCSpeaker(), 1);
}
