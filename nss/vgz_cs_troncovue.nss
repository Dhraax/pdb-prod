void main()
{
  object oPC = GetLastUsedBy();
  object oTarget = GetWaypointByTag("troncovuelta");
  location lTarget = GetLocation(oTarget);

  AssignCommand(oPC, ClearAllActions());
  AssignCommand(oPC, ActionJumpToLocation(lTarget));
}
