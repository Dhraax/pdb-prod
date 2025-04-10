void main()
{
object oPC = GetPCSpeaker();

    effect eHeal = EffectHeal(9999);
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_G);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
}
