int StartingConditional()
{
object oPC = GetPCSpeaker();

//Anillo de resistencia mental ilicido
string sAro = "arodeanilloilcid";
string sGema = "gemadeanilloilci";
string sDiente = "dientedeazotam";

if (GetCampaignInt("CROMWELL", "ANILLOILICIDO", oPC) == 1) return FALSE;

if((GetItemPossessedBy(oPC, sAro) != OBJECT_INVALID)  &&
   (GetItemPossessedBy(oPC, sGema) != OBJECT_INVALID) &&
   (GetItemPossessedBy(oPC, sDiente) != OBJECT_INVALID)) return FALSE;
return TRUE;
}
