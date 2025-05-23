void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("bajada_cloak_puer_ciu_esmel");
    DeleteLocalInt(oPC, "ESMEL_MALOS_PUERT_CIUD");
    AssignCommand(oPC, JumpToObject(oTarget));
}

