void main()
{
    object oPC = GetLastUsedBy ();
    object oTarget = GetWaypointByTag("subir_cueva_lago_mis");
    AssignCommand(oPC, JumpToObject(oTarget));
}


