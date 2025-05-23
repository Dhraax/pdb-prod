void main()
{
object oPC = GetPCSpeaker();
object oTarget;
location lTarget;
oTarget = GetWaypointByTag("crs_cabala");
lTarget = GetLocation(oTarget);
if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;
AssignCommand(oPC, ClearAllActions());
AssignCommand(oPC, ActionJumpToLocation(lTarget));
}

