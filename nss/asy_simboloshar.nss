void main()
{
    object oSimboloShar= GetObjectByTag("");
    effect e1 = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
    int iVar=GetLocalInt(OBJECT_SELF, "asy_armasombra");
    if (iVar==0)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,e1,oSimboloShar);
        SetLocalInt(OBJECT_SELF, "asy_estatua", 1);


    }

}
