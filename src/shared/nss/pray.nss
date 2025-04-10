void main()
{
  object oPC = GetEnteringObject();
  object oSiomir = GetNearestObjectByTag("LithSiomir", oPC);

  AssignCommand(oSiomir, ClearAllActions());
  DelayCommand(1.0, AssignCommand(oSiomir, SetFacing(180.0)));
  DelayCommand(1.0, AssignCommand(oSiomir, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 99999.0)));
}
