#include "mti_libreria"

void main()
{
object oPC = GetPCSpeaker();
GuardarIntPersistente(oPC,"QUEST_CN_NINFA",2);
AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, 5);
object oMascara = CreateItemOnObject("ko_quest_nin_mas",GetPCSpeaker());
}
