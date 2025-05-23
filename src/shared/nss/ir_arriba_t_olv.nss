void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("templo_olv_arriba");
    AssignCommand(oPC, JumpToObject(oTarget));
}


