void main()
{
object oPC = GetPCSpeaker();

SetCampaignInt("ko_laura", "ko_quest_nashkel_2", 3, oPC); //Apuntamos que ha obrado legalmente
object oLlave = CreateItemOnObject("llavceldanashkel",GetPCSpeaker()); //damos la llave del mauselo Kensiddar
}

