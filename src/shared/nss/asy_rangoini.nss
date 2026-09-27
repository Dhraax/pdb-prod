// modified by: Dhraax
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if (GetIsPC(oPC) == TRUE)
    {

        int iRango = GetLocalInt(oPC, "iRange");
        if (iRango == 0)
        {
            iRango = 35;
        }
        SetCustomToken(93011, IntToString(iRango));

        return TRUE;
    }
    return FALSE;
}
