#include "nw_i0_plot"
void main()
{
  object oPC = GetPCSpeaker();
  object oTarget = GetNearestObjectByTag("tyr_tiendacenti");

  gplotAppraiseOpenStore(oTarget, oPC, 0, 0);
}
