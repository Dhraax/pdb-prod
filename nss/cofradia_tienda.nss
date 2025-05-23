#include "nw_i0_plot"

void main()
{
  object oPC = GetPCSpeaker();
  object oTarget = GetObjectByTag("cofradia_tienda");

  gplotAppraiseOpenStore(oTarget, oPC, 0, 0);
}
