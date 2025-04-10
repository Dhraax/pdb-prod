int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("ko_lyrethe", "ko_quest", oPC);

if(nComprobarVar == 1) return TRUE;

return FALSE;
}
