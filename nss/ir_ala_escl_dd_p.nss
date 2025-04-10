void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = GetWaypointByTag("hacia_escl_esmel_puerto");
    AssignCommand(oPC, JumpToObject(oTarget));
}

