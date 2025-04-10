 void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = GetWaypointByTag("tortugahinchada");
    AssignCommand(oPC, JumpToObject(oTarget));
}

