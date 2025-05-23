void main()
{
object oPC = GetPCSpeaker();
location lPuntoDeRuta = GetLocation(GetWaypointByTag("red_sarcofag"));

if (GetAreaFromLocation(lPuntoDeRuta) == OBJECT_INVALID) return;
AssignCommand(oPC, ClearAllActions());
AssignCommand(oPC, ActionJumpToLocation(lPuntoDeRuta));
}
