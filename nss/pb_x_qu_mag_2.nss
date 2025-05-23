int StartingConditional()
{
object oPC = GetPCSpeaker();
int iVariable = GetCampaignInt("QUESTAMNAGUATORRE", "AVANCE", oPC);

if(iVariable == 1)
return TRUE;
return FALSE;
}
