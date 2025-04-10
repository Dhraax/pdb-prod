
void main()
{
object oPC = GetLastUsedBy();
string sTagWP = GetTag(OBJECT_SELF);
object theWaypoint = GetWaypointByTag(sTagWP);
DelayCommand(2.0, AssignCommand(oPC, JumpToLocation(GetLocation(theWaypoint))));
}


