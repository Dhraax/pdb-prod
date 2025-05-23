int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("QUESTILICITOS", "AVANCE", oPC);

if(nComprobarVar == 1)
return TRUE;
return FALSE;
}
