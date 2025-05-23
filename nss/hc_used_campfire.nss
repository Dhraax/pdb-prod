void main()
{
    object oPC = GetPCSpeaker();
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, 120.0));
}
