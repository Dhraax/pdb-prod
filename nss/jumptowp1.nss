void main()
{
    object oUser = GetLastUsedBy();

    if(!GetIsPC(oUser)) return;

    AssignCommand(oUser, ClearAllActions());
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2), oUser);
    DelayCommand(1.3, AssignCommand(oUser, JumpToObject(GetWaypointByTag("Temple_arach"))));
}
