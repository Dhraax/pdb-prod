#include "mti_libreria"

void main()
{
object oPC = GetPCSpeaker();
object oItemToTake;

GiveGoldToCreature(oPC, 5000);
GiveXPToCreature(oPC, 1000);

oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "CabezadeldruidasombriodeWeldath");
GuardarIntPersistente(oPC,"ALCALDECARAVASAR",7);

if(GetIsObjectValid(oItemToTake) != 0)
    DestroyObject(oItemToTake);
}
