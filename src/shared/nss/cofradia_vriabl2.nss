int StartingConditional()
{
object oPC = GetPCSpeaker();

if(GetCampaignInt("GESTALADRONES", "AVANCE", oPC) == 2)
return FALSE;
return TRUE;
}
