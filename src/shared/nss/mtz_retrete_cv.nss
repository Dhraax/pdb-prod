void main()
{

object oPC = GetLastUsedBy();
object oWay = GetWaypointByTag ("mtz_casaviejaalc");
location lWay = GetLocation(oWay);

AssignCommand (oPC, ClearAllActions());
AssignCommand (oPC, ActionJumpToLocation (lWay));

}
