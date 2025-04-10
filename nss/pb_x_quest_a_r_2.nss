int StartingConditional()
{

object oPC = GetPCSpeaker();
int iVariable = GetCampaignInt("quest_ratas_amn", "jefe_amn_conto", oPC);

if(iVariable >= 2)
return TRUE;
return FALSE;
}
