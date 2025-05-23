void main()
{
object oPC = GetLastUsedBy();
location lPuente1 = GetLocation(GetWaypointByTag("gamb_puente11"));
location lPuente2 = GetLocation(GetWaypointByTag("gamb_puente22"));

if(GetTag(OBJECT_SELF) == "gamb_puente1")
   {
      AssignCommand(oPC, ClearAllActions());
      AssignCommand(oPC, ActionJumpToLocation(lPuente1));
   }

if(GetTag(OBJECT_SELF) == "gamb_puente2")
   {
      AssignCommand(oPC, ClearAllActions());
      AssignCommand(oPC, ActionJumpToLocation(lPuente2));
   }
}
