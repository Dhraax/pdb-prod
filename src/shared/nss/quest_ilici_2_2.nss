int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("QUESTILICITOS", "RESCATE", oPC);

if(nComprobarVar == 1) return TRUE;
return FALSE;
}
