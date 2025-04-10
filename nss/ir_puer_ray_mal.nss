void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("Templ_rayo_5");
    AssignCommand(oPC, JumpToObject(oTarget));
}

