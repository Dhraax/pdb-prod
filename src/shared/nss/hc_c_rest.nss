void main()
{
    object oPC = GetLastSpeaker();

    SetLocalInt(oPC, "REST", 1);
    DelayCommand(2.0, AssignCommand(oPC, ActionRest()));
}

