int StartingConditional()
{
object oPC = GetPCSpeaker();

//Mangual de las Edades +3
string sAcido = "cabezadeacido";
string sHielo = "cabezadehielo";
string sFuego = "cabezadefuego";

if (GetCampaignInt("CROMWELL", "MANGUALEDADES", oPC) == 1) return FALSE;

if((GetItemPossessedBy(oPC, sAcido) != OBJECT_INVALID) &&
   (GetItemPossessedBy(oPC, sHielo) != OBJECT_INVALID) &&
   (GetItemPossessedBy(oPC, sFuego) != OBJECT_INVALID)) return FALSE;
return TRUE;
}
