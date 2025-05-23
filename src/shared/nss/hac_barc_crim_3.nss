void main()
{
  object oPC = GetEnteringObject();
  object oTarget = GetObjectByTag("Athk_Crimm_3");

  DelayCommand(30.0, AssignCommand(oPC, JumpToObject(oTarget)));
}

