void main()
{
object oPC = GetLastUsedBy();
object oTarget = GetWaypointByTag("calav_2");
location lTarget = GetLocation(oTarget);

ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), oPC);
FloatingTextStringOnCreature("*Giras la antorcha*", oPC, FALSE);
DelayCommand(2.4, AssignCommand(oPC, ClearAllActions()));
DelayCommand(2.5, AssignCommand(oPC, ActionJumpToLocation(lTarget)));
}
