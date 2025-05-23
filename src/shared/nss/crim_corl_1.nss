int StartingConditional()
{
object oPC = GetPCSpeaker();
int iVariable = GetCampaignInt("QUESTCAMINOORCO", "AVANCE", oPC);

if((iVariable) == 2)
return TRUE;
return FALSE;
}
