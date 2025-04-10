void main()
{
       object oPC = GetLastUsedBy();
       object oTarget = GetWaypointByTag("mek_salidaSecretaACala");
       location lTarget = GetLocation(oTarget);
       DelayCommand(0.9, AssignCommand(oPC, ClearAllActions()));
       DelayCommand(1.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));
}
