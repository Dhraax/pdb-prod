void main()
{
  object oPC = GetLastUsedBy();
  object oLugar1 = GetNearestObjectByTag("crs_Ooscu");
  object oLugar2 = GetNearestObjectByTag("crs_Columna1");
  object oLugar3 = GetNearestObjectByTag("crs_Columna2");
effect eOscuridad = EffectVisualEffect(VFX_DUR_DARKNESS);
effect eShadow = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eOscuridad, oLugar1, 300.0);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShadow, oLugar1, 300.0);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShadow, oLugar2, 300.0);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShadow, oLugar3, 300.0);

}
