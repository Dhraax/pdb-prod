void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("Galeria_Salida_A");
    AssignCommand(oPC, JumpToObject(oTarget));
}

