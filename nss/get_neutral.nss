int StartingConditional()
{
    object oPC = GetLastSpeaker();
    int iResult = FALSE;

    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_NEUTRAL) {
        iResult = TRUE;
    }

    return iResult;
}
