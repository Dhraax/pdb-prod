void main()
{
    object oPC= GetItemActivator();
    effect eVisual = EffectVisualEffect(816);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eVisual,oPC);

}
