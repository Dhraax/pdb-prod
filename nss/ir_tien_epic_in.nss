void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("tiend_epica_esmel_entrada");
    AssignCommand(oPC, JumpToObject(oTarget));
}
