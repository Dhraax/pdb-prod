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
        SetCustomToken(500, IntToString(iRango));

        return TRUE;
    }
    return FALSE;
}
