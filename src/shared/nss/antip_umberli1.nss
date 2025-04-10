void main()
{
int iSuerte = d10(1);

if(iSuerte == 1)
    {
    object oWP = GetNearestObjectByTag("WP_Guardianumberli");
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_WEIRD),GetLocation(oWP));
    }
}
