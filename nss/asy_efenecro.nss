void main()
{
    object oPC = GetEnteringObject();
    if (GetIsPC(oPC)==TRUE)
    {

        effect eVis1 = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
        effect eVis2 = EffectVisualEffect(VFX_DUR_AURA_RED_DARK);
        object oAsyubi = GetNearestObjectByTag("asy_necrodisco");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eVis1,oAsyubi);
        SetLocalInt(oAsyubi, "X1_L_IMMUNE_TO_DISPEL", 10);
        oAsyubi = GetNearestObjectByTag("asy_necrodiosa");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eVis1,oAsyubi);
        SetLocalInt(oAsyubi, "X1_L_IMMUNE_TO_DISPEL", 10);
        oAsyubi = GetObjectByTag("asy_necropiramide");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eVis2,oAsyubi);
        SetLocalInt(oAsyubi, "X1_L_IMMUNE_TO_DISPEL", 10);


    }
}
