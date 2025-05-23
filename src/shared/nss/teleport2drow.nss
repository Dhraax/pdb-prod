void main()
{
    object oUser = GetLastUsedBy();

    if(!GetIsPC(oUser)) return;

    AssignCommand(oUser, ClearAllActions());
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD), oUser);
    DelayCommand(1.3, AssignCommand(oUser, JumpToObject(GetWaypointByTag("entrada_conjuracion"))));
}
