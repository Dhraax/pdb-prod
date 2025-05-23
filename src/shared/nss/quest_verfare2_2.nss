int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("quest_huevos", "verfare", oPC);

if(!(nComprobarVar == 2)) return FALSE;

return TRUE;
}


