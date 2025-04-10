#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();
GuardarIntPersistente(oPC, "QUEST_VENGA_ESMEL_8", 8);
    // Dar un poco de oro al que habla
    GiveGoldToCreature(GetPCSpeaker(), 25000);

    // Dar algunos PX al que habla
    GiveXPToCreature(GetPCSpeaker(), 6000);
}
