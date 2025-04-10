#include "nw_i0_plot"

void main()
{

object oPC = GetPCSpeaker();

object oTarget;
oTarget = GetObjectByTag("sidras");

gplotAppraiseOpenStore(oTarget, oPC, 0, 0);

}

