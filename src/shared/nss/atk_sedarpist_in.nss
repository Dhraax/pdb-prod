void main()
{
  object oPC = GetPCSpeaker();
  object oTarget = GetWaypointByTag("in_sedearpista");
  location lTarget = GetLocation(oTarget);

  AssignCommand(oPC, ClearAllActions());
  AssignCommand(oPC, ActionJumpToLocation(lTarget));
}
