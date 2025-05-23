void main()
{
int iHechizo = GetLastSpell();
effect eVisual = EffectVisualEffect(VFX_FNF_DISPEL);

    if(iHechizo == SPELL_LESSER_DISPEL)
        {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVisual,OBJECT_SELF);
        DelayCommand(1.0,DestroyObject(OBJECT_SELF));
        }
    if(iHechizo == SPELL_GREATER_DISPELLING)
        {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVisual,OBJECT_SELF);
        DelayCommand(1.0,DestroyObject(OBJECT_SELF));
        }
    if(iHechizo == SPELL_DISPEL_MAGIC)
        {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVisual,OBJECT_SELF);
        DelayCommand(1.0,DestroyObject(OBJECT_SELF));
        }
    if(iHechizo == SPELL_MORDENKAINENS_DISJUNCTION)
        {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVisual,OBJECT_SELF);
        DelayCommand(1.0,DestroyObject(OBJECT_SELF));
        }
}
