#include "mti_libreria"

void main()
{
object oPC = GetPCSpeaker();
object item = GetItemPossessedBy(oPC, "grantrozodelkrak");

if(GetIsObjectValid(item) == TRUE) DestroyObject(item);

GiveGoldToCreature(oPC,10000);
GiveXPToCreature(oPC,2000);

GuardarIntPersistente(oPC, "QUEST_IRPHONG",2);
}
