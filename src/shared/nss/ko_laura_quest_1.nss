void main()
{
object oPC = GetPCSpeaker();

SetCampaignInt("ko_laura", "ko_quest_nashkel_2", 2, oPC); //Apuntamos que habla con Laura para pedir permiso
GiveXPToCreature(GetPCSpeaker(), 500);
}

