void main()
{
    object oSimboloShar= GetObjectByTag("asy_simshar");
    object oSimboloShar2= GetObjectByTag("asy_simshar_2");
    object oBola1 = GetObjectByTag("asy_bola1");
    object oBola2 = GetObjectByTag("asy_bola2");
    effect e1 = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e1,oSimboloShar,999999.9);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e1,oSimboloShar2,999999.9);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e1,oBola1,999999.9);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e1,oBola2,999999.9);

}
