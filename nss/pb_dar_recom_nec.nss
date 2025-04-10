void main()
{
object oPC = GetPCSpeaker();

SetCampaignInt("matanecrarios", "quest", 2, oPC);

GiveGoldToCreature(GetPCSpeaker(), 10000);
GiveXPToCreature(GetPCSpeaker(), 2000);

object oCalavera = GetItemPossessedBy(oPC, "CalaveradelosMatanecrarios");
if(GetIsObjectValid(oCalavera)) DestroyObject(oCalavera);
}
