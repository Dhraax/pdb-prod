int StartingConditional()
{
object oPC = GetPCSpeaker();

if(GetCampaignInt("QUESTPURSKUL", "AVANCE", oPC) >= 1)

return TRUE;
return FALSE;
}
