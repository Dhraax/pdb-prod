int StartingConditional()
{
object oPC = GetPCSpeaker();

if(GetCampaignInt("PESCADERO_MURAN", "ESPECIES", oPC) == 2) return FALSE;
return TRUE;
}
