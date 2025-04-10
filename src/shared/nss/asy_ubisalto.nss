void main()
{
    string sSaltoJug = GetLocalString(OBJECT_SELF, "sSalto");
    object oPC = GetLastUsedBy();
    if (GetIsPC(oPC) == TRUE)
    {
       location lSalto = GetLocation(GetWaypointByTag(sSaltoJug));
       AssignCommand(oPC, JumpToLocation(lSalto));

    }
}
