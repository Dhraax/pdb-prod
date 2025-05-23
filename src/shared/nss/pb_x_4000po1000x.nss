void main()
{
GiveGoldToCreature(GetPCSpeaker(), 2500);

GiveXPToCreature(GetPCSpeaker(), 1250);

object oPC = GetPCSpeaker();
SetCampaignInt("quest_ratas_amn", "jefe_amn_conto", 3, oPC);

object oItem = GetItemPossessedBy(oPC, "CabezadelLderdellosHombresRata");
if (GetIsObjectValid(oItem)) DestroyObject(oItem);
}
