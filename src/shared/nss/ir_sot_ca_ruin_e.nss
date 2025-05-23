void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("sotano_cas_ruin_mercesmel");
    AssignCommand(oPC, JumpToObject(oTarget));
}

