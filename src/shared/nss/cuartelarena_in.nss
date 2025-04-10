void main()
{
object oPC = GetPCSpeaker();

if(!GetIsPC(oPC)) return;


       object oTarget = GetWaypointByTag("cuartel_entrar_arena");
       location lTarget = GetLocation(oTarget);

       if(GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

       DelayCommand(0.9, AssignCommand(oPC, ClearAllActions()));
       DelayCommand(1.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));


}
