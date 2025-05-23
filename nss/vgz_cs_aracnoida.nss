void main()
{
object oPC = GetEnteringObject();

object oTarget = GetWaypointByTag("cs_aracnoida");
location lTarget = GetLocation(oTarget);

//FloatingTextStringOnCreature("*Caes en lo que parece ser una trampa aracnida!*",oPC);
AssignCommand(oPC, ClearAllActions());
AssignCommand(oPC, ActionJumpToLocation(lTarget));


}
