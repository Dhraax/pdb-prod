int StartingConditional()
{
object oPC = GetPCSpeaker();
int iVariable = GetCampaignInt("PESCADERO_MURAN", "ESPECIES", oPC);

if(((iVariable) == 1) && (GetItemPossessedBy(oPC, "asy_muranespecies") != OBJECT_INVALID))
return TRUE;
return FALSE;
}
