#include "mti_libreria"

void main()
{
object oPC = GetPCSpeaker();
GuardarIntPersistente(oPC,"QUEST_CAMINOCOSTA_DRIANNA",3); //Es neutral
GiveXPToCreature(GetPCSpeaker(), 750);
object oCadaver = GetItemPossessedBy(oPC, "ko_missy");
if(GetIsObjectValid(oCadaver)) DestroyObject(oCadaver);
}
