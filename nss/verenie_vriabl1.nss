#include "nw_i0_tool"
void main()
{
object oPC = GetPCSpeaker();
object oItem = GetItemPossessedBy(oPC, "ZEP_CRE_EMTG");

SetCampaignInt("VERENIE", "AVANCE", 1, oPC);

if (GetIsObjectValid(oItem)) DestroyObject(oItem);

RewardPartyXP(750, oPC, FALSE);
RewardPartyGP(1000, oPC, FALSE);
CreateItemOnObject("yelmopro", oPC);
}
