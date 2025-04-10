int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = GetCampaignInt("quest_ratas_amn", "jefe_amn_conto", oPC);

if(nComprobarVar == 3) return TRUE;
return FALSE;
}
