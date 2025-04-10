int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("ko_hayla_quest", "ko_quest_nashkel_3", oPC);

if(nComprobarVar == 2) return TRUE; //Comprobamos que ha terminado la quest

return FALSE;
}
