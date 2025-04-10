void main()
{
object oPC = GetPCSpeaker();

SetCampaignInt("ko_darek", "ko_quest_nashkel_1", 3, oPC); //Apuntamos que coge el amuleto
object oAmuleto = CreateItemOnObject("amuletodeloskens",GetPCSpeaker()); //damos el amuleto al personaje

}

