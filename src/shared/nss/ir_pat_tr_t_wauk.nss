void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("subida_temp_waukin_cg");
    AssignCommand(oPC, JumpToObject(oTarget));
}

