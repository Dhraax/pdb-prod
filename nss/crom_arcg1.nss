int StartingConditional()
{
object oPC = GetPCSpeaker();

//Arco corto de Gesen
string sArco = "arcodemadera";
string sCuerda = "cuerdadearcocort";

if (GetCampaignInt("CROMWELL", "ARCOGESEN", oPC) == 1) return FALSE;

if ((GetItemPossessedBy(oPC, sArco) != OBJECT_INVALID) &&
    (GetItemPossessedBy(oPC, sCuerda) != OBJECT_INVALID)) return FALSE;
return TRUE;
}
