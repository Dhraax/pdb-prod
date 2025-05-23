// sr5.3
// Added code to check to see if resting in armor is set on if not do not display
// this option.
int StartingConditional()
{
    int iResult = FALSE;
    object oPC = GetPCSpeaker();
    if (GetLocalInt(GetModule(),"RESTARMORPEN"))
        iResult = TRUE;
    return iResult;
}
