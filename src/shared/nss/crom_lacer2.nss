int StartingConditional()
{
object oPC = GetPCSpeaker();

//Lacerahielos +3
string sEscama = "fhgtrhtrs";
string sFiloLa = "filodehachadelos";

if (GetCampaignInt("CROMWELL", "LACERAHIELOS", oPC) == 1) return FALSE;

if (GetItemPossessedBy(oPC, sEscama) == OBJECT_INVALID) return FALSE;

if (GetItemPossessedBy(oPC, sFiloLa) == OBJECT_INVALID) return FALSE;

return TRUE;
}
