void main()
{
object oPC = GetPCSpeaker();

SetCampaignInt("FRIAGO", "AVANCE", 2, oPC);
GiveXPToCreature(oPC, 750);
GiveGoldToCreature(oPC, 750);

object oItem = GetItemPossessedBy(oPC, "suministros");
if (GetIsObjectValid(oItem)) DestroyObject(oItem);
}
