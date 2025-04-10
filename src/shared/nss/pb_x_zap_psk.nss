#include "nw_i0_plot"
void main()
{
object oPC = GetPCSpeaker();
object oTarget = GetObjectByTag("zapatera_purskul");

gplotAppraiseOpenStore(oTarget, oPC, 0, 0);
}
