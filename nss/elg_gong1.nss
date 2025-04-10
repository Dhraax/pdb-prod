void FuncionCrearObjeto(int oTipoObjeto, string sResref, location lUbicacion)
{
  CreateObject(oTipoObjeto, sResref, lUbicacion, TRUE);
}

void main()
{
  object oPC = GetLastUsedBy();
  object oMod = GetModule();
  location lUbicacionBalor = GetLocation(GetWaypointByTag("WP_elg_balorsombrio"));

  FloatingTextStringOnCreature("* El gong suena fuertemente *", oPC);
  AssignCommand(oPC, PlaySound("as_cv_gongring3"));
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PROT_STONESKIN), OBJECT_SELF, 1200.0);
  SetLocalInt(OBJECT_SELF, "UBICADOACTIVADO", TRUE);
  DelayCommand(1200.0, DeleteLocalInt(OBJECT_SELF, "UBICADOACTIVADO"));

  DelayCommand(20.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), lUbicacionBalor));
  DelayCommand(23.3, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), lUbicacionBalor));
  DelayCommand(26.6, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), lUbicacionBalor));
  DelayCommand(30.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIRESTORM), lUbicacionBalor));
  DelayCommand(30.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_GATE), lUbicacionBalor));
  DelayCommand(32.0, FuncionCrearObjeto(OBJECT_TYPE_CREATURE, "nw_hellhound", lUbicacionBalor));
  DelayCommand(32.0, FuncionCrearObjeto(OBJECT_TYPE_CREATURE, "nw_beastxvim", lUbicacionBalor));
  DelayCommand(32.0, FuncionCrearObjeto(OBJECT_TYPE_CREATURE, "x2_pitfiend001", lUbicacionBalor));
  DelayCommand(32.0, FuncionCrearObjeto(OBJECT_TYPE_CREATURE, "elg_balor", lUbicacionBalor));
}
