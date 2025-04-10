int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("quest", "minas naskel", oPC);

if(!(nComprobarVar == 2)) return FALSE;

return TRUE;
}


