#include "mti_libreria"
void main()
{
    object oPC = GetPCSpeaker();
    GiveGoldToCreature(oPC,650);
    GiveXPToCreature(oPC,700);
    GuardarIntPersistente(oPC,"QUEST_NUEVONECRO",7);
}
