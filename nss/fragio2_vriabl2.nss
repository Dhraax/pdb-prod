int StartingConditional()
{
object oPC = GetPCSpeaker();
int iVariable = GetCampaignInt("FRIAGO", "AVANCE", oPC);

if(((iVariable) == 1) && (GetItemPossessedBy(oPC, "suministros") != OBJECT_INVALID))
return TRUE;
return FALSE;
}

