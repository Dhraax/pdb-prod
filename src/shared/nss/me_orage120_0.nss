void main()
{
    int n=1;location loc=GetLocalLocation(GetPCSpeaker(),"location meteo");
    object area=GetArea( GetPCSpeaker());
    float ori=GetFacingFromLocation(loc);
    vector pos=  GetPositionFromLocation(loc);

    while (n<=120)
    {
        effect eff=EffectVisualEffect(VFX_IMP_LIGHTNING_M,TRUE);
        DelayCommand(IntToFloat(n)/2,ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eff,Location(area,Vector(pos.x+(Random(50)-25), pos.y+(Random(50)-25),pos.z), ori)));
        n++;
    }
}
