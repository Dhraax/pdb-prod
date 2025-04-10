#include "nw_i0_plot"
void main()
{
object oPC = GetPCSpeaker();
object oTarget = GetObjectByTag("almacen_ust_natha_1");

gplotAppraiseOpenStore(oTarget, oPC, 0, 0);
}
