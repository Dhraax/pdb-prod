void main()
{
object oPC = GetPCSpeaker();
object oTarget = GetWaypointByTag("mago_amn_sala_4");
effect eVis_1 = EffectVisualEffect(VFX_IMP_HEALING_X);
effect eVis_2 = EffectVisualEffect(VFX_IMP_BREACH);
effect eCurar = EffectHeal(GetMaxHitPoints(oPC) - GetCurrentHitPoints(oPC));

ApplyEffectToObject(DURATION_TYPE_INSTANT, eCurar, oPC);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis_1, oPC);
DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis_2, oPC));

DelayCommand(0.4, AssignCommand(oPC, ClearAllActions()));
DelayCommand(0.5, AssignCommand(oPC, ActionJumpToObject(oTarget)));

CreateObject(OBJECT_TYPE_CREATURE, "harpy002", GetLocation(GetWaypointByTag("arpia_1")));
}
