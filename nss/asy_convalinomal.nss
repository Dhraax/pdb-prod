int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if (!(GetAlignmentGoodEvil(oPC)==ALIGNMENT_EVIL)) return TRUE;

    return FALSE;

}
