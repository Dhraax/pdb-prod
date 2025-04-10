void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("tiend_epica_esmel_salida");
    AssignCommand(oPC, JumpToObject(oTarget));
}

