int StartingConditional()
{
object oPC = GetPCSpeaker();

if(GetCampaignInt("VERENIE", "AVANCE", oPC) == 1)
return FALSE;
return TRUE;
}
