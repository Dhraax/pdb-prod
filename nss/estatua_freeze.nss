void main()
{
effect eFreeze = SupernaturalEffect(EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION));

DelayCommand(0.1,ApplyEffectToObject(DURATION_TYPE_PERMANENT,eFreeze,OBJECT_SELF));

}
