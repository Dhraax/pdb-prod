void main()
{
    object  oAtacante = GetLastAttacker();

    effect eDamage = EffectDamage(d10(1),DAMAGE_TYPE_NEGATIVE);
    effect eNegativo = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oAtacante));
    DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eNegativo,oAtacante));
}
