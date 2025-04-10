int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("quest_huevos", "verfare", oPC);

if(!(nComprobarVar == 1)) return FALSE;

return TRUE;
}

