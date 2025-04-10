#include "mti_libreria"
void main()
{
    object oPC = GetPCSpeaker();
    GiveGoldToCreature(oPC,450);
    GiveXPToCreature(oPC,700);
    GuardarIntPersistente(oPC,"QUEST_NUEVONECRO",3);
}
