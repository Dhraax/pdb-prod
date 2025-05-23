int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("ko_laura", "ko_quest_nashkel_2", oPC);

if(nComprobarVar == 2) return TRUE; //comprobamos que ha pedido permiso a Laura

return FALSE;
}
