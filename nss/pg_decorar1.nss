void main()
{
  if(GetIsPC(GetEnteringObject()) == FALSE) return;

  int iUnaVez = GetLocalInt(OBJECT_SELF, "DECORAR_PLANO_FUGA");
  if(iUnaVez == TRUE) return;

  SetLocalInt(OBJECT_SELF, "DECORAR_PLANO_FUGA", TRUE);
  DelayCommand(20.0, DeleteLocalInt(OBJECT_SELF, "DECORAR_PLANO_FUGA"));

  object oCalavera = GetNearestObjectByTag("pg_calavera1");
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY), GetLocation(oCalavera));
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIREBALL), GetLocation(oCalavera));
  DelayCommand(2.00, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY), GetLocation(oCalavera)));
  DelayCommand(2.00, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIREBALL), GetLocation(oCalavera)));
  DelayCommand(4.00, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY), GetLocation(oCalavera)));
  DelayCommand(4.00, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIREBALL), GetLocation(oCalavera)));
  DelayCommand(6.00, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY_FEMALE), GetLocation(oCalavera)));
  DelayCommand(6.00, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIREBALL), GetLocation(oCalavera)));
  DelayCommand(6.00, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_AURA_PULSE_RED_BLUE), oCalavera, 30.0));

  object oAlma = GetNearestObjectByTag("pg_alma" + IntToString(d4()));
  DelayCommand(4.00, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH), oAlma));
}
