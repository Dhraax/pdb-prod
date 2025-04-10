#include "mti_libreria"

void main()
{
object oPC = GetPCSpeaker();
GuardarIntPersistente(oPC,"QUEST_CN_NINFA",3); //Es caotico
GiveGoldToCreature(GetPCSpeaker(), 5000);
GiveXPToCreature(GetPCSpeaker(), 1000);
}
