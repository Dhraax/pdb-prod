#include "mti_libreria"

void main()
{
object oPC = GetPCSpeaker();
GuardarIntPersistente(oPC,"QUEST_CAMINOCOSTA_DRIANNA",4); //Es Bueno
AdjustAlignment(oPC, ALIGNMENT_GOOD, 5);
GiveXPToCreature(GetPCSpeaker(), 750);
object oCadaver = GetItemPossessedBy(oPC, "ko_missy");
if(GetIsObjectValid(oCadaver)) DestroyObject(oCadaver);
object oCopiaGato = GetItemPossessedBy(oPC, "ko_missy_hijo");
if(GetIsObjectValid(oCopiaGato)) DestroyObject(oCopiaGato);

}
