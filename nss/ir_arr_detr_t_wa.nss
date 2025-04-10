void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("subida_temp_waukin_cript");
    AssignCommand(oPC, JumpToObject(oTarget));
}

