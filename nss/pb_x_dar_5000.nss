void main()
{
GiveGoldToCreature(GetPCSpeaker(), 3500);

GiveXPToCreature(GetPCSpeaker(), 1250);

object oPC = GetPCSpeaker();
SetCampaignInt("quest_ratas_amn", "jefe_amn_conto", 2, oPC);

object oItem = GetItemPossessedBy(oPC, "CabezadelLderdellosHombresRata");
if (GetIsObjectValid(oItem)) DestroyObject(oItem);
}
