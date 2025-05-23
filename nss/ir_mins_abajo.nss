void main()
{
    object oPC = GetLastUsedBy ();
    object oTarget = GetWaypointByTag("bajar_cueva_lago_mis");
    AssignCommand(oPC, JumpToObject(oTarget));
}

