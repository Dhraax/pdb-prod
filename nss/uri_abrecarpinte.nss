#include "nw_i0_plot"

void main()
{
  object oPC = GetPCSpeaker();
  object oTienda = GetNearestObjectByTag("MaestroCoramRuedarit");

  gplotAppraiseOpenStore(oTienda, oPC, 0, 0);
}
