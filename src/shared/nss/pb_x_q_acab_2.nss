int StartingConditional()
{

object oPC = GetPCSpeaker();
int iVariable = GetCampaignInt("QUESTAMNAGUATORRE", "AVANCE", oPC);

if(iVariable == 2)
return TRUE;
return FALSE;
}
