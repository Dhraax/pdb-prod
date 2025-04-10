void main()
{
object oPC = GetPCSpeaker();

SetCampaignInt("ko_laura", "ko_quest_nashkel_2", 4, oPC); //Apuntamos que ha actuado sin preguntar a Laura
object oLlave = CreateItemOnObject("llavceldanashkel",GetPCSpeaker()); //damos la llave del mauselo Kensiddar

GiveXPToCreature(GetPCSpeaker(), 500);
}

