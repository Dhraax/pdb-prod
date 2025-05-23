void main()
{
  object oPC = GetEnteringObject();
  object oTarget = GetObjectByTag("atk_puerto");

  DelayCommand(30.0, AssignCommand(oPC, JumpToObject(oTarget)));
}
