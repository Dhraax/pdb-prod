#include "mti_libreria"
void main()
{
    // Dar los objetos al que habla
    CreateItemOnObject("llav_cementer_es", GetPCSpeaker(), 1);
object oPC = GetPCSpeaker();
GuardarIntPersistente(oPC, "AVISO_CEMENTERIO", 2);
}
