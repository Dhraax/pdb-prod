void main()
{
object oPC = GetPCSpeaker();

SetCampaignInt("ko_edwing_quest", "ko_quest_nashkel_4", 3, oPC); //Termina quest

GiveGoldToCreature(GetPCSpeaker(), 10000);
GiveXPToCreature(GetPCSpeaker(), 2500);

}
