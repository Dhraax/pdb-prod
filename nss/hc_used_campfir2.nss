void main()
{
    object oPC = GetPCSpeaker();
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 6.0));
    DelayCommand(1.5, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
    DestroyObject(OBJECT_SELF, 6.1);
}
