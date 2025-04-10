void main()
{
    object oPC = GetLastSpeaker();
    object oAtacker = OBJECT_SELF;

    SetIsTemporaryEnemy(oPC, oAtacker);
    DelayCommand(1.0, AssignCommand(oAtacker, ActionAttack(oPC)));
}
