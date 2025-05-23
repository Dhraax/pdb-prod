void main()
{
  object oPC = GetPCSpeaker();
  effect eExplosionSonido = EffectVisualEffect(VFX_FNF_SOUND_BURST);
  location lWeldazh = GetLocation(GetWaypointByTag("pn_wpweldazh"));

  ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplosionSonido, oPC);
  DelayCommand(1.0, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(1.1, AssignCommand(oPC, ActionJumpToLocation(lWeldazh)));
}
