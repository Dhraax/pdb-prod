void main()
{
    object oPC = GetClickingObject();
    object oTarget = GetWaypointByTag("sortida_cofradia_esmel");
    AssignCommand(oPC, JumpToObject(oTarget));
}

