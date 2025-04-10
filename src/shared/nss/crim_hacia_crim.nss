void main()
{
object oPC = GetPCSpeaker();
location lTarget = GetLocation(GetWaypointByTag("crimmor"));

if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;
AssignCommand(oPC, ClearAllActions());
AssignCommand(oPC, ActionJumpToLocation(lTarget));
}
