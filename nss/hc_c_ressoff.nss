// hcr3

int StartingConditional()
{
    object oMod = GetModule();
    int iResult;
    if (GetLocalInt(oMod, "RESSPORT"))
        iResult = TRUE;
    else
        iResult = FALSE;
    return iResult;
}
