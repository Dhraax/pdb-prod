int StartingConditional()
{
    object oPC = GetLastSpeaker();
    int iResult = FALSE;

    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD) {
        iResult = TRUE;
    }

    return iResult;
}
