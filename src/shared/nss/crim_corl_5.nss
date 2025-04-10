void main()
{
object oPC = GetPCSpeaker();
object oInforme = GetItemPossessedBy(oPC, "informedelalcald");

if (GetIsObjectValid(oInforme)) DestroyObject(oInforme);

SetCampaignInt("QUESTCAMINOORCO", "AVANCE", 4, oPC);
}
