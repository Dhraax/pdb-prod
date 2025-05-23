void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = GetWaypointByTag("patio_cas_aband");
    AssignCommand(oPC, JumpToObject(oTarget));
}
