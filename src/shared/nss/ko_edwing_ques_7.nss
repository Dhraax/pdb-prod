int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("ko_edwing_quest", "ko_quest_nashkel_4", oPC);

if(nComprobarVar == 3) return TRUE; //comprobamos que ha realizado la quest
return FALSE;
}
