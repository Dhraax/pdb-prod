#include "mti_libreria"

void main()
{
object oPC = GetPCSpeaker();
GuardarIntPersistente(oPC,"QUEST_CN_NINFA",3); //Es legal o neutral
AdjustAlignment(oPC, ALIGNMENT_LAWFUL, 5);

object oMascara = GetItemPossessedBy(oPC, "ko_quest_nin_mas");
if(GetIsObjectValid(oMascara)) DestroyObject(oMascara);
object oAnillo = CreateItemOnObject("ko_quest_nin_ani",GetPCSpeaker());
GiveGoldToCreature(GetPCSpeaker(), 5000);
GiveXPToCreature(GetPCSpeaker(), 1000);
}
