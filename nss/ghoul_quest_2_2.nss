int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("ghoul", "quest", oPC);

if(!(nComprobarVar == 2)) return FALSE;

return TRUE;
}

