int StartingConditional()
{
object oPC = GetPCSpeaker();
int iVariable = GetCampaignInt("AGUJASDEORO", "AVANCE", oPC);

if(((iVariable) == 1) && (GetItemPossessedBy(oPC, "torso_golem") != OBJECT_INVALID))

return TRUE;
return FALSE;
}
