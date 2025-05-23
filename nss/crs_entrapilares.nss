void main()
{
object oLugar1 = GetNearestObjectByTag("crs_cl1");
object oLugar2 = GetNearestObjectByTag("crs_cl2");
object oLugar3 = GetNearestObjectByTag("crs_cl3");
object oLugar4 = GetNearestObjectByTag("crs_cl4");
effect eShadow = EffectVisualEffect(537);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShadow, oLugar1, 300.0);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShadow, oLugar4, 300.0);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShadow, oLugar2, 300.0);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShadow, oLugar3, 300.0);

}
