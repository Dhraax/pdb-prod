#include "mti_libreria"
void main()
{
    object oPC = GetPCSpeaker();
    // Dar algunos PX al que habla
    GiveXPToCreature(GetPCSpeaker(), 500);
    GuardarIntPersistente(oPC, "MARIUS_RELIQUIA", 1);
    // Dar los objetos al que habla
    CreateItemOnObject("reliquiafamiliar", GetPCSpeaker(), 1);
}
