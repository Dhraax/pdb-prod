
void main()
{
    object oCespe = GetObjectByTag("pnj_bpCespenar");
    int idado = d4(1);
    string sText;
    switch (idado)
    {
        case 1: sText = "WP_pnj_bpCespenar1_01"; break;
        case 2: sText = "WP_pnj_bpCespenar1_02"; break;
        case 3: sText = "WP_pnj_bpCespenar1_03"; break;
        case 4: sText = "WP_pnj_bpCespenar1_04"; break;
        default: sText = "WP_pnj_bpCespenar1_01"; break;
    }
    location lCespe  = GetLocation(GetWaypointByTag(sText));

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD), GetLocation(oCespe));
    DestroyObject(oCespe);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD), lCespe);
    CreateObject(OBJECT_TYPE_CREATURE, "pb_cespenar", lCespe, FALSE, "pnj_bpCespenar");


}
