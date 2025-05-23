int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("ko_lyrethe", "ko_quest", oPC);

if(!(nComprobarVar == 2)) return FALSE;

return TRUE;
}


