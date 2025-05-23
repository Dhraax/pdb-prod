int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("ko_acotarquestdarek", "ko_quest_nashkel_acotar", oPC);

if(nComprobarVar == 1) return TRUE; //comprobamos que ha hablado con Darek ya

return FALSE;
}
