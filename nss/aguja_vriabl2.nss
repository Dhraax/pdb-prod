int StartingConditional()
{
object oPC = GetPCSpeaker();

if(GetCampaignInt("AGUJASDEORO", "AVANCE", oPC) == 2)
return FALSE;
return TRUE;
}
