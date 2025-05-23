void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("pl_agu_hacia_2");
    AssignCommand(oPC, JumpToObject(oTarget));
}

