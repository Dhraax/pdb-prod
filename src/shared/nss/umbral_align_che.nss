int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nAlign = GetAlignmentGoodEvil(oPC);
    string sParam = GetScriptParam("OPTION");

    if(sParam == "CRIATURA_BUENA" && nAlign == ALIGNMENT_EVIL) return FALSE;
    else if(sParam == "CRIATURA_MALIGNA" && nAlign == ALIGNMENT_GOOD) return FALSE;
    else return TRUE;
}
