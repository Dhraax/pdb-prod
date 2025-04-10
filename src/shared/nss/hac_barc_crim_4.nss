void main()
{
  object oPC = GetEnteringObject();
  object oTarget = GetObjectByTag("crimmor");

  DelayCommand(30.0, AssignCommand(oPC, JumpToObject(oTarget)));
}
