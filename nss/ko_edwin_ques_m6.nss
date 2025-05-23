int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("ko_edwing_malo_quest", "ko_quest_nashkel_5", oPC);

if(nComprobarVar == 2) return TRUE; //comprobamos que ha quemado el libro

return FALSE;
}
