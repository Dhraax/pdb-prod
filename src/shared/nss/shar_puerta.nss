void main()
{
    object oUser = GetLastUsedBy();

    if(!GetIsPC(oUser)) return;

    AssignCommand(oUser, ClearAllActions());
    AssignCommand(oUser, JumpToObject(GetWaypointByTag("entrada_shar")));
}
