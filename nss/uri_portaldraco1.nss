void main()
{
  object oPC = GetLastUsedBy();
  object oTarget = GetWaypointByTag("uri_portaldraco1");
  location lTarget = GetLocation(oTarget);

  if(GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

  DelayCommand(2.9, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(3.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD), GetLocation(oTarget));

  FloatingTextStringOnCreature("El portal se activa.", oPC);
}
