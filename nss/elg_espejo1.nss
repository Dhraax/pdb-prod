void FuncionCrearObjeto(int oTipoObjeto, string sResref, location lUbicacion)
{
  CreateObject(oTipoObjeto, sResref, lUbicacion, TRUE);
}

void main()
{
  object oPC = GetLastUsedBy();
  location lUbicacionLiche = GetLocation(GetWaypointByTag("WP_elg_melviarn"));

  FloatingTextStringOnCreature("¡Has liberado un gran mal! ¡Detrás de ti!", oPC);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(80), OBJECT_SELF);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PROT_STONESKIN), OBJECT_SELF, 1200.0);
  SetLocalInt(OBJECT_SELF, "UBICADOACTIVADO", TRUE);
  DelayCommand(1200.0, DeleteLocalInt(OBJECT_SELF, "UBICADOACTIVADO"));

  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_GATE), lUbicacionLiche);
  DelayCommand(2.0, FuncionCrearObjeto(OBJECT_TYPE_CREATURE, "elg_melviarn", lUbicacionLiche));
  DelayCommand(2.0, FuncionCrearObjeto(OBJECT_TYPE_CREATURE, "zep_dklord_001", lUbicacionLiche));
  DelayCommand(2.0, FuncionCrearObjeto(OBJECT_TYPE_CREATURE, "zep_dklord_001", lUbicacionLiche));
}
