void main()
{
object oPC = GetPCSpeaker();

SetCampaignInt("PESCADERO_MURAN", "ESPECIES", 2, oPC);
GiveXPToCreature(oPC, 500);
GiveGoldToCreature(oPC, 500);

object oItem = GetItemPossessedBy(oPC, "asy_muranespecies");
if (GetIsObjectValid(oItem)) DestroyObject(oItem);
}
