void main()
{
    int n=1;
    location loc=GetLocalLocation(GetPCSpeaker(),"location meteo");
    object area=GetArea( GetPCSpeaker());
    float ori=GetFacingFromLocation(loc);
    vector pos=  GetPositionFromLocation(loc);

    while (n<=60)
    {
        effect eff=EffectVisualEffect(VFX_FNF_ICESTORM,TRUE);
        DelayCommand(IntToFloat(n),ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eff,Location(area,Vector(pos.x+(Random(50)-25), pos.y+(Random(50)-25),pos.z), ori)));
        n++;
    }
    DelayCommand(60.00,AssignCommand(GetPCSpeaker(),ExecuteScript("me_orage2",GetPCSpeaker())));

}
