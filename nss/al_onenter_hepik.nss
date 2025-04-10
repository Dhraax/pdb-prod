void main()
{
    object oPC = GetEnteringObject();

    if(GetIsPC(oPC) && GetLocalString(GetEnteringObject(), "PeqEntCasa") != "")
    {
        AssignCommand(oPC, SetFacing(GetFacing(GetObjectByTag("WP_JumpPeqEnt_he"))));
        SendMessageToPC(oPC, "Has entrado en la herreria, pero acabas de divisar un pequeo problema...");
    }
}
