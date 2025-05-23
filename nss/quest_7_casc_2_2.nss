int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("quest_drow", "siete_cascos", oPC);

if(!(nComprobarVar == 2)) return FALSE;

return TRUE;
}

