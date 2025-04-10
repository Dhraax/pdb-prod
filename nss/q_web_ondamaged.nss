// If damaged by fire, the web is automatically destroyed

void main()
{
    if (GetDamageDealtByType(DAMAGE_TYPE_FIRE) >= 1)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), OBJECT_SELF);
        DestroyObject(OBJECT_SELF, 1.5);
    }
}
