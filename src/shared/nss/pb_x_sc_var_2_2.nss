int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("QUESTJABALIES", "YAMELOCONTO", oPC);

if(!(nComprobarVar == 2)) return FALSE;

return TRUE;
}
