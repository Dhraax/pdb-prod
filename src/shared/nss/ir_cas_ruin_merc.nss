void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("baj_soto_cas_ruin_merc_esmel");
    AssignCommand(oPC, JumpToObject(oTarget));
}

