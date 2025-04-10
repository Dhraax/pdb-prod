#include "x2_inc_itemprop"

void main()
{
    object oContenedor = GetObjectByTag("spawn_encuentros");
    int iReg= GetLocalInt(oContenedor,"Reg");
    object oPC = GetPCSpeaker();
    effect eRegen = ExtraordinaryEffect(EffectRegenerate(iReg, 6.0));
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    ForceRest(oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegen, oPC);





}
