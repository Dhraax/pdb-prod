void main()
{
    object oStatue = GetObjectByTag("pb_estasacerbaal");
    location lStatue = GetLocation(oStatue);
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oStatue, 2.0);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), lStatue, 2.0);

}
