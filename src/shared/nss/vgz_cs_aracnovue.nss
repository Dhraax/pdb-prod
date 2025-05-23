void main()
{
object oPC = GetPCSpeaker();

object oTarget = GetWaypointByTag("cs_aracnovue");
location lTarget = GetLocation(oTarget);

FloatingTextStringOnCreature("*Trepas por las rocas hasta un salir por un agujero estrecho*",oPC);
AssignCommand(oPC, ClearAllActions());
DelayCommand(0.5,AssignCommand(oPC, ActionJumpToLocation(lTarget)));


}
