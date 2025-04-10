int StartingConditional()
{

object oPC = GetPCSpeaker();
int iVariable = GetCampaignInt("QUESTAMNAGUATORRE", "AVANCE", oPC);

if(iVariable == 4)
return TRUE;
return FALSE;
}
