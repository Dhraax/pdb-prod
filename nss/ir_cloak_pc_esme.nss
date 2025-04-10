void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("baj_puert_ciudad_esmel");
    SetLocalInt(oPC, "ESMEL_MALOS_PUERT_CIUD", 1);
    AssignCommand(oPC, JumpToObject(oTarget));
}
