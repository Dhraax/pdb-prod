void main()
{
    effect e1 = EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION);
    effect e2 = EffectVisualEffect(VFX_DUR_PROT_GREATER_STONESKIN);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT,e1,OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,e2,OBJECT_SELF);
}
