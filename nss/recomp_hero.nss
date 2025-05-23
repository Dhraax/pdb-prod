#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();
// Dar un poco de oro al que habla
GiveGoldToCreature(oPC, 2000);

// Dar algunos PX al que habla
GiveXPToCreature(oPC, 1500);

GuardarIntPersistente(oPC, "QUEST_HERO", 1);

object oHorus = GetItemPossessedBy(oPC, "X0_IT_MTHNMISC13");

if(GetIsObjectValid(oHorus)) DestroyObject(oHorus);
}
