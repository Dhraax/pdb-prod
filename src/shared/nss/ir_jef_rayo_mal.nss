void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("Templ_rayo_jefe_final");
    AssignCommand(oPC, JumpToObject(oTarget));
}

