void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("hacia_lvl_1");
    AssignCommand(oPC, JumpToObject(oTarget));
}

