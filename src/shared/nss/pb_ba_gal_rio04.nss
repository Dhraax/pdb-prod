void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("Galeria_Salida_B");
    AssignCommand(oPC, JumpToObject(oTarget));
}

