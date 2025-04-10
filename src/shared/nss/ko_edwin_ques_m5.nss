#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();

SetCampaignInt("ko_edwing_malo_quest", "ko_quest_nashkel_5", 2, oPC); //Apuntamos que quema el libro
AdjustAlignment(oPC, ALIGNMENT_EVIL, 10);
}

