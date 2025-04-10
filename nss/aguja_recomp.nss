int StartingConditional()
{
object oPC = GetPCSpeaker();

//La Igualadora
string sFiloIg = "filodelaigualado";
string sJoya = "joyadelaigualado";
string sMango = "pomodelaigualado";

if (GetCampaignInt("CROMWELL", "IGUALADORA", oPC) == 1) return FALSE;

if (GetItemPossessedBy(oPC, sFiloIg) == OBJECT_INVALID) return FALSE;

if (GetItemPossessedBy(oPC, sJoya) == OBJECT_INVALID) return FALSE;

if (GetItemPossessedBy(oPC, sMango) == OBJECT_INVALID) return FALSE;

return TRUE;
}
