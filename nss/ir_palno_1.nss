void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("pl_agu_hacia_espej");
    AssignCommand(oPC, JumpToObject(oTarget));
}

