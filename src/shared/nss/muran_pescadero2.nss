int StartingConditional()
{
object oPC = GetPCSpeaker();

if(GetCampaignInt("PESCADERO_MURAN", "ESPECIES", oPC) >= 1) return FALSE;
return TRUE;
}
