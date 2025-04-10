void main()
{
       object oPC = GetPCSpeaker();
       object oTarget = GetWaypointByTag("mek_waypointEntradaBaja");
       location lTarget = GetLocation(oTarget);
       DelayCommand(0.9, AssignCommand(oPC, ClearAllActions()));
       DelayCommand(1.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));
}
