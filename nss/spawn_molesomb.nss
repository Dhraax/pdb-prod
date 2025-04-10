void main()
{
  effect eDerr = EffectVisualEffect(353);
  effect eShake = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
  DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDerr,OBJECT_SELF));
  DelayCommand(0.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eShake,OBJECT_SELF));

  // BIOWARE IA
  ExecuteScript( "nw_c2_default9", OBJECT_SELF);
}
