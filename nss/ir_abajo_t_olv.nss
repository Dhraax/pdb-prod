void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("templo_olv_abajo");
    AssignCommand(oPC, JumpToObject(oTarget));
}


