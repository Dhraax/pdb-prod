#include "mti_libreria"

void main()
{
object oPC = GetPCSpeaker();
object oItemToTake;

GiveGoldToCreature(oPC, 2000);
GiveXPToCreature(oPC, 500);
AdjustAlignment(oPC, ALIGNMENT_GOOD, 5);

oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "uri_mantowauken");
GuardarIntPersistente(oPC,"QUEST_CARAVASAR_ALIKABAR",2);

if(GetIsObjectValid(oItemToTake) != 0)
    DestroyObject(oItemToTake);
}
