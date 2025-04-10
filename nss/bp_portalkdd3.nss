#include "mti_libreria"
void main()
{
  object oPC = GetLastUsedBy();
  object oPR = GetWaypointByTag("bp_cupula3");
  location lPR = GetLocation(oPR);

  Teletransporte2(oPC, lPR);
}
