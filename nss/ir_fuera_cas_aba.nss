void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("salida_casa_aband_esmel");
    AssignCommand(oPC, JumpToObject(oTarget));
}

