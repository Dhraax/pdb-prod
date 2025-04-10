void main()
{
  object oPC = GetLastUsedBy();
  object oMod = GetModule();
  object oTarget = GetWaypointByTag("llegada_templo");

  AssignCommand(oPC, JumpToObject(oTarget));

  if(GetLocalInt(oMod, "DESAPARECERPORTAL") == 0)
  {
      SetLocalInt(oMod, "DESAPARECERPORTAL", 1);
      DelayCommand(100.0, DeleteLocalInt(oMod, "DESAPARECERPORTAL"));
      DelayCommand(100.0, DestroyObject(OBJECT_SELF));
      DelayCommand(100.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_CELESTIAL), GetLocation(OBJECT_SELF)));
  }
}
