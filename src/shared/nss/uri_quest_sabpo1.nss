#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();
    // Dar algunos PX al que habla
    GiveXPToCreature(GetPCSpeaker(), 1000);
GuardarIntPersistente(oPC, "QUEST_SAB_POP_MERCADERES", 1);
}
