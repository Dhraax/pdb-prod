int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("ko_darek", "ko_quest_nashkel_1", oPC);

if(nComprobarVar == 1) return TRUE; //comprobamos que ha hablado con el bardo

return FALSE;
}
