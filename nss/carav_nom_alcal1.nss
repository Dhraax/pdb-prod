#include "mti_libreria"

void main()
{
    object oPC = GetPCSpeaker();

    GiveGoldToCreature(oPC, 500);
    GiveXPToCreature(oPC, 200);
    GuardarIntPersistente(oPC, "ALCALDECARAVASAR", 1);

}
