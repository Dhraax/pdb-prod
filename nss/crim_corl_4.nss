int StartingConditional()
{
object oPC = GetPCSpeaker();
int iVariable = GetCampaignInt("QUESTCAMINOORCO", "AVANCE", oPC);

if(((iVariable) == 3) && (GetItemPossessedBy(oPC, "informedelalcald") != OBJECT_INVALID))

return TRUE;
return FALSE;
}
