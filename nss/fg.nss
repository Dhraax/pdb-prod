int StartingConditional()
{
object oPC = GetPCSpeaker();
int iVariable = GetCampaignInt("QUESTCAMINOORCO", "AVANCE", oPC);

if(((iVariable) == 1) && (GetItemPossessedBy(oPC, "capaceteorco") != OBJECT_INVALID))

return TRUE;
return FALSE;
}
