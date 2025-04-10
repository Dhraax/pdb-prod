void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("salida_cueva_drow");
    AssignCommand(oPC, JumpToObject(oTarget));
}

