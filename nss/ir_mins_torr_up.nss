void main()
{
    object oPC = GetLastUsedBy ();
    object oTarget = GetWaypointByTag("subir_torre_mis");
    AssignCommand(oPC, JumpToObject(oTarget));
}

