int StartingConditional()
{

object oPC = GetPCSpeaker();
int iVariable = GetCampaignInt("QUESTAMNAGUATORRE", "AVANCE", oPC);

if(iVariable == 3)
return TRUE;
return FALSE;
}

