void main()
{

    string sTag = GetTag(OBJECT_SELF);
    location lLocal1= GetLocation(GetObjectByTag("asy_diosashar1"));
    effect e1 = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
    int iVar=GetLocalInt(OBJECT_SELF, "asy_estatua");
    if (iVar==0)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e1,OBJECT_SELF,180.0);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,EffectVisualEffect(VFX_IMP_HARM),lLocal1);
        //ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectVisualEffect(VFX_FNF_PWKILL),OBJECT_SELF);
        SetLocalInt(OBJECT_SELF, "asy_estatua", 1);


    }
    DelayCommand(180.0, SetLocalInt(OBJECT_SELF, "asy_estatua",0));
    DelayCommand(180.0,SetListening(OBJECT_SELF, FALSE));
}
