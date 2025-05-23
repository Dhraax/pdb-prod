int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("QUESTJABALIES", "YAMELOCONTO", oPC);

if(!(nComprobarVar == 1)) return FALSE;

return TRUE;
}
