void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("claustro_psk_subida");
    AssignCommand(oPC, JumpToObject(oTarget));
}

