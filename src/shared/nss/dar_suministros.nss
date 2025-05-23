int StartingConditional()
{
object oPC = GetPCSpeaker();

if(GetCampaignInt("AGUJASDEORO", "AVANCE", oPC) == 1)
return FALSE;
return TRUE;
}
