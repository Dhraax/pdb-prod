void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("Galeria_Entrada_B");
    AssignCommand(oPC, JumpToObject(oTarget));
}

