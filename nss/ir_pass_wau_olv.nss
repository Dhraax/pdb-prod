void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("ir_pass_olv_wauk");
    DelayCommand(0.5, PlayAnimation(ANIMATION_PLACEABLE_OPEN));
    DelayCommand(1.5, AssignCommand(oPC, JumpToObject(oTarget)));
    DelayCommand(3.5, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
}
