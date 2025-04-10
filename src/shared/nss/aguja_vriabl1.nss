#include "nw_i0_tool"
void main()
{
object oPC = GetPCSpeaker();
object oItem = GetItemPossessedBy(oPC, "torso_golem");

SetCampaignInt("AGUJASDEORO", "AVANCE", 2, oPC);

if(GetIsObjectValid(oItem)) DestroyObject(oItem);
RewardPartyXP(1500, oPC, FALSE);
RewardPartyGP(2500, oPC, FALSE);
}
