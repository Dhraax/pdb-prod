void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = GetWaypointByTag("subida_vam_v_tramp");
    AssignCommand(oPC, JumpToObject(oTarget));
    DeleteLocalInt(oPC, "GHOUL_CIRIPT_VV");
}

