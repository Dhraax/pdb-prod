#include "mti_libreria"

void main()
{
object oPC = GetPCSpeaker();
object oItemToTake;

GiveGoldToCreature(oPC, 2000);
GiveXPToCreature(oPC, 500);

oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "uri_mantowauken");
GuardarIntPersistente(oPC,"ALCALDECARAVASAR",4);
GuardarIntPersistente(oPC,"NOBLESBURLADOS",1);

if(GetIsObjectValid(oItemToTake) != 0)
    DestroyObject(oItemToTake);
}
