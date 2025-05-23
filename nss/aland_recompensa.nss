#include "nw_i0_tool"
void main()
{
object oPC = GetPCSpeaker();
object oCapacete = GetItemPossessedBy(oPC, "capaceteorco");

//if (GetIsObjectValid(oCapacete)) DestroyObject(oCapacete);

RewardPartyXP(2500, oPC, FALSE);
RewardPartyGP(2000, oPC, FALSE);

SetCampaignInt("QUESTCAMINOORCO", "AVANCE", 2, oPC);
}
