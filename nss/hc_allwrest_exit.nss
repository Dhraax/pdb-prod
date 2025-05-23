// sr6.1
// using script to remove good effects subrace code in that script.
// added text message to explain why to PCs.
// sr 5.5
// added check to see if subraces is set.
//sr 5.3
// use this script in a area on_exit event to remove any magical effects
// on the pc when they leave a unlimited resting area.
// note: this prevents abuse by players casting buffs on friends and reresting
#include "hc_inc_remgood"
#include "hc_text_rest"

void main()
{
object oTarget = GetExitingObject();
if (!GetIsDM(oTarget))
    RemoveGoodEffects( oTarget );
if (GetIsPC(oTarget))
    SendMessageToPC(oTarget, EXITREST);

}
