void main()
{
  object oPC = GetLastUsedBy();
  object oTarget = GetWaypointByTag("troncoida");
  location lTarget = GetLocation(oTarget);

  AssignCommand(oPC, ClearAllActions());
  AssignCommand(oPC, ActionJumpToLocation(lTarget));
}
