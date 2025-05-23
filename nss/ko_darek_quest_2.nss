void main()
{
object oPC = GetPCSpeaker();

SetCampaignInt("ko_darek", "ko_quest_nashkel_1", 2, oPC); //Apuntamos que habla con darek, despues de hablar con bardo
SetCampaignInt("ko_laura", "ko_quest_nashkel_2", 1, oPC); //Apuntamos que tiene la posibilidad de pedir permiso a Laura
SetCampaignInt("ko_acotarquestdarek", "ko_quest_nashkel_acotar", 1, oPC); //Apuntamos que habla con Darek, para que no pueda volver a salir la cancion del bardo
}
