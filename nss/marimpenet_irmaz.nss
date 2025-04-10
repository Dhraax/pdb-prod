void main()
{
object oPC = GetEnteringObject();

if(!GetIsPC(oPC)) return;

object oTarget = GetWaypointByTag("maztica_port");
location lTarget = GetLocation(oTarget);

DelayCommand(0.9, AssignCommand(oPC, ClearAllActions()));
DelayCommand(1.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));
}
