#include "nw_i0_tool"
void main()
{
object oPC = GetPCSpeaker();

SetCampaignInt("QUESTILICITOS", "AVANCE", 2, oPC);

// Dar un poco de oro al que habla
GiveGoldToCreature(GetPCSpeaker(), 6000);

// Dar algunos PX al que habla
RewardPartyXP(2000, GetPCSpeaker(), FALSE);
}
