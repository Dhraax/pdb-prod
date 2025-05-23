void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("arriba_agujero");
    AssignCommand(oPC, JumpToObject(oTarget));
}

