void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = GetWaypointByTag("contravandistas_drow_pic");
    AssignCommand(oPC, JumpToObject(oTarget));
}
