void main()
{
object oPC = GetEnteringObject();

if (!GetIsPC(oPC)) return;
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR),GetObjectByTag("sidetower"));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR),GetObjectByTag("dragon"));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR),GetObjectByTag("flags"));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR),GetObjectByTag("tree"));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR),GetObjectByTag("steps"));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR),GetObjectByTag("X0_TRAP_FBALL"));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR),GetObjectByTag("ShadowPine4"));
}
