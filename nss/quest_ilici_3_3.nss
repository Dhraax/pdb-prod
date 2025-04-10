int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("QUESTILICITOS", "AVANCE", oPC);

if(nComprobarVar == 2) return TRUE;
return FALSE;
}
