int StartingConditional()
{
object oPC = GetPCSpeaker();

//Asoladora +4
string sAsta = "astadelaasolador";
string sFilo = "filodelaasolador";

if (GetCampaignInt("CROMWELL", "ASOLADORA", oPC) == 1) return FALSE;

if (GetItemPossessedBy(oPC, sAsta) == OBJECT_INVALID) return FALSE;

if (GetItemPossessedBy(oPC, sFilo) == OBJECT_INVALID) return FALSE;

return TRUE;
}
