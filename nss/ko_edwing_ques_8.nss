int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("ko_edwing_quest", "ko_quest_nashkel_4", oPC);
int nComprobarMalo = GetCampaignInt("ko_edwing_malo_quest", "ko_quest_nashkel_5", oPC);

if((nComprobarVar == 3)&&(nComprobarMalo == 2)) return TRUE; //comprobamos que ha realizado la quest y es malo
return FALSE;
}
