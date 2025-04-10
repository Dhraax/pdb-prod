#include "mti_libreria"

void main()
{
object oPC = GetPCSpeaker();
GuardarIntPersistente(oPC,"QUEST_CAMINOCOSTA_DRIANNA",2); //Es malo
AdjustAlignment(oPC, ALIGNMENT_EVIL, 5);
GiveXPToCreature(GetPCSpeaker(), 750);
object oCadaver = GetItemPossessedBy(oPC, "ko_missy");
if(GetIsObjectValid(oCadaver)) DestroyObject(oCadaver);

}
