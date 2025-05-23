#include "nw_i0_tool"
void main()
{
object oPC = GetPCSpeaker();
object oItem = GetItemPossessedBy(oPC, "relikia");

if (GetIsObjectValid(oItem)) DestroyObject(oItem);

RewardPartyXP(200, oPC, FALSE);
RewardPartyGP(550, oPC, FALSE);
}
