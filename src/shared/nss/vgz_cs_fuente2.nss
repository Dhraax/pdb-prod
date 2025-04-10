#include "x0_i0_petrify"
void main()
{
object oPC = GetEnteringObject ();
int iAli = GetAlignmentGoodEvil(oPC);

if (
(iAli == ALIGNMENT_GOOD || iAli == ALIGNMENT_NEUTRAL) &&
(GetIsPC (oPC) == TRUE))
{
RemoveEffectOfType(oPC,EFFECT_TYPE_REGENERATE);

}

}
