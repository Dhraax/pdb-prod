int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("ko_edwing_quest", "ko_quest_nashkel_4", oPC);

if(nComprobarVar == 2) return TRUE; //comprobamos que ha aceptado

return FALSE;
}
