void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("hacia_lvl_2");
    AssignCommand(oPC, JumpToObject(oTarget));
}

