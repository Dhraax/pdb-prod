#include "mti_libreria"
void main()
{
    object oPC = GetPCSpeaker();
    // Dar algunos PX al que habla
    GiveXPToCreature(GetPCSpeaker(), 700);
    AdjustAlignment(oPC, ALIGNMENT_EVIL, 10);
    GuardarIntPersistente(oPC, "SALVAR_VICONIA", 1);
}
