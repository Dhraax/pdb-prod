void main()
{
  string sTag = GetTag(OBJECT_SELF);
  effect e1 = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);

  ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e1,OBJECT_SELF,60.0);
  DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e1,GetNearestObjectByTag(sTag+"b"),60.0));
  DelayCommand(4.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e1,GetNearestObjectByTag(sTag+"c"),60.0));

  SetLocalInt(OBJECT_SELF, "ESTATUA", 1);
  DelayCommand(60.0, DeleteLocalInt(OBJECT_SELF, "ESTATUA"));
}
