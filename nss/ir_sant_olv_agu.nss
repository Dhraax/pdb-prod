void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("Pl_agu_sant_olv");
    AssignCommand(oPC, JumpToObject(oTarget));
}

