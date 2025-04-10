int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if (!(GetAlignmentGoodEvil(oPC)==ALIGNMENT_EVIL)) return FALSE;

    return TRUE;

}

