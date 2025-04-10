void main()
{
object oPC = GetPCSpeaker();
object oTarget = GetWaypointByTag("calav_3");
location lTarget = GetLocation(oTarget);

if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

AssignCommand(oPC, ClearAllActions());

AssignCommand(oPC, ActionJumpToLocation(lTarget));
}
