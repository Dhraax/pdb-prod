void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("Galeria_Entrada_A");
    AssignCommand(oPC, JumpToObject(oTarget));
}

