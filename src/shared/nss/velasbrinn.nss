//Viajar Brinn_Ley

void main()
{
  object oPC = GetLastSpeaker();

  object oTarget;
  location lTarget;
  oTarget = GetWaypointByTag("brynnley_port");

lTarget = GetLocation(oTarget);


if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

AssignCommand(oPC, ClearAllActions());

DelayCommand(1.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));


}
