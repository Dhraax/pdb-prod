#include "mti_libreria"

void main()
{
    object oPC = GetPCSpeaker();

    GiveXPToCreature(oPC, 100);
    CreateItemOnObject("escudodearmon", oPC, 1);

    GuardarIntPersistente(oPC, "MAESTRECARAVASAR", 1);

}

