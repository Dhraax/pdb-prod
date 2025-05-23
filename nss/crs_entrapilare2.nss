void main()
{
object oLugar1 = GetNearestObjectByTag("crs_cl5");
object oLugar2 = GetNearestObjectByTag("crs_cl6");
object oLugar3 = GetNearestObjectByTag("crs_cl7");
object oLugar4 = GetNearestObjectByTag("crs_cl8");
object oLugar5 = GetNearestObjectByTag("crs_gr1");
object oLugar6 = GetNearestObjectByTag("crs_gr2");
object oLugar7 = GetNearestObjectByTag("crs_gr3");
object oLugar8 = GetNearestObjectByTag("crs_gr4");
object oLugar9 = GetNearestObjectByTag("crs_gr5");
object oLugar10 = GetNearestObjectByTag("crs_gr6");
object oLugar11 = GetNearestObjectByTag("crs_gr7");
object oLugar12 = GetNearestObjectByTag("crs_gr8");
effect eShadow = EffectVisualEffect(537);
effect eSombra = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShadow, oLugar1, 999.0);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShadow, oLugar4, 999.0);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShadow, oLugar2, 999.0);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShadow, oLugar3, 999.0);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSombra, oLugar5, 999.0);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSombra, oLugar6, 999.0);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSombra, oLugar7, 999.0);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSombra, oLugar8, 999.0);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSombra, oLugar9, 999.0);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSombra, oLugar10, 999.0);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSombra, oLugar11, 999.0);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSombra, oLugar12, 999.0);
}
