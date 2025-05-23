#include "nw_i0_plot"
void main()
{
object oPC = GetPCSpeaker();
object oTarget = GetObjectByTag("bi_elurion");

gplotAppraiseOpenStore(oTarget, oPC, 10, 10);
}
