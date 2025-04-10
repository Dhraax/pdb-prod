void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("misnor_casa_aband");
    AssignCommand(oPC, JumpToObject(oTarget));
}

