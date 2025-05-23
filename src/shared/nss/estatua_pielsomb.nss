void main()
{
       effect ePetrify = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePetrify, OBJECT_SELF);
    SetLocalInt(OBJECT_SELF, "X1_L_IMMUNE_TO_DISPEL", 10);

}
