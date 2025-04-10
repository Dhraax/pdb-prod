int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarQuestLyretha = GetCampaignInt("ko_lyrethe", "ko_quest", oPC);
int nComprobarQuestHayla = GetCampaignInt("ko_hayla_quest", "ko_quest_nashkel_3", oPC);
int nComprobarEntrega = GetCampaignInt("ko_darek", "ko_quest_nashkel_1", oPC);
int nComprobarLegalidad = GetCampaignInt("ko_laura", "ko_quest_nashkel_2", oPC);


if((nComprobarQuestLyretha == 2)&&(nComprobarQuestHayla == 2)&&(nComprobarEntrega == 4)&&(nComprobarLegalidad == 3)) return TRUE; //Comprobamos que hizo las quest de Hayla y Lyretha y Laura bien hechas

return FALSE;
}


