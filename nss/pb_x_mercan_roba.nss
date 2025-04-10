#include "nw_i0_plot"
void main()
{
  object oPC = GetPCSpeaker();
  object oTienda = GetObjectByTag("mercado_negro_1");

  gplotAppraiseOpenStore(oTienda, oPC);
}
