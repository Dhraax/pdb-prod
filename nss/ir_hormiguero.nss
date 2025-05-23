void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("hormiguero_salida");
    AssignCommand(oPC, JumpToObject(oTarget));
}

