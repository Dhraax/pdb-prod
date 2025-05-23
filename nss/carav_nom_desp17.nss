#include "mti_libreria"

void main()
{
object oPC = GetPCSpeaker();
object oItemToTake = GetItemPossessedBy(oPC, "CuerpoinconscientedeTyris");

GiveXPToCreature(oPC, 200);
GuardarIntPersistente(oPC,"DESPELLEJADOR_FINAL_GUAY",1);

if (GetIsObjectValid(oItemToTake)) DestroyObject(oItemToTake);
}














