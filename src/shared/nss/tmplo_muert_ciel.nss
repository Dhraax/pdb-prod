void main()
{
  object oPC = GetLastUsedBy();
  object oTarget = GetWaypointByTag("WP_ESC2_TO_ESC3");
  location lTarget = GetLocation(oTarget);

  AssignCommand(oPC, ClearAllActions());
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), oPC);
  DelayCommand(3.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));
}
