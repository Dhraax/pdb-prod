//Viajar Skaug

void main()
{
  object oPC = GetLastSpeaker();

  object oTarget;
  location lTarget;
  oTarget = GetWaypointByTag("skaug_port");

lTarget = GetLocation(oTarget);


if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

AssignCommand(oPC, ClearAllActions());

DelayCommand(1.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));

}
