int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarEntrega = GetCampaignInt("ko_darek", "ko_quest_nashkel_1", oPC);
int nComprobarLegalidad = GetCampaignInt("ko_laura", "ko_quest_nashkel_2", oPC);

if((nComprobarEntrega == 4)&&(nComprobarLegalidad == 4))return TRUE; //comprobamos que ha entregado el amuleto y ha actuado mal

return FALSE;
}
