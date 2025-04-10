#include "nw_i0_plot"
void main()
{
object oPC = GetPCSpeaker();
object oTarget = GetObjectByTag("ko_tienda_arcana_buena");

gplotAppraiseOpenStore(oTarget, oPC, 0, 0);
}
