int StartingConditional()
{
    object oPC = GetLastSpeaker();
    int iResult = FALSE;

    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL) {
        iResult = TRUE;
    }

    return iResult;
}
