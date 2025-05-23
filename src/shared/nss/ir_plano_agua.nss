void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = GetWaypointByTag("plano_agua");
    effect eVis_1 = EffectVisualEffect(VFX_IMP_AC_BONUS);
    effect eVis_2 = EffectVisualEffect(VFX_IMP_DEATH_WARD);
    effect eVis_3 = EffectVisualEffect(VFX_IMP_FROST_L);
    effect eVis_4 = EffectVisualEffect(VFX_IMP_GOOD_HELP);
    effect eVis_5 = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis_1, oPC));
    DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis_2, oPC));
    DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis_3, oPC));
    DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis_4, oPC));
    DelayCommand(5.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis_5, oPC));
    DelayCommand(6.0, AssignCommand(oPC, JumpToObject(oTarget)));
    DelayCommand(6.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis_5, oPC));
}
