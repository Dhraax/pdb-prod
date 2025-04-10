void main()
{
object oPC = GetPCSpeaker();

SetCampaignInt("ko_edwing_quest", "ko_quest_nashkel_4", 1, oPC); //Apuntamos que acepta la quest
object oInforme = CreateItemOnObject("InformedeEdwingMatanecrarios",GetPCSpeaker()); //damos el informe
}

