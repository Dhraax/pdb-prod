int StartingConditional()
{

object oPC = GetPCSpeaker();
int iVariable = GetCampaignInt("quest_ratas_amn", "jefe_amn_conto", oPC);

if(iVariable == 1)
return TRUE;
return FALSE;
}
