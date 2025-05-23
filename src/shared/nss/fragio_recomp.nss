#include "nw_i0_plot"
void main()
{
object oPC = GetPCSpeaker();
object oTarget = GetNearestObjectByTag("vampiros_ghoul");

gplotAppraiseOpenStore(oTarget, oPC, 0, 0);
}
