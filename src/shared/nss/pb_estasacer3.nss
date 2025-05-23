void main()
{

    DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD), OBJECT_SELF));
    DelayCommand(3.0, DestroyObject(OBJECT_SELF));

}
