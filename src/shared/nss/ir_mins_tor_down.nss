void main()
{
    object oPC = GetLastUsedBy ();
    object oTarget = GetWaypointByTag("bajar_torre_mis");
    AssignCommand(oPC, JumpToObject(oTarget));
}

