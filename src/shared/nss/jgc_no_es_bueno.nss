int StartingConditional()
{
    object oPC= GetLastSpeaker();
    string sSubraza = GetStringLowerCase(GetSubRace(oPC));
    int iBondad = GetAlignmentGoodEvil(oPC);
    if((sSubraza != "elfo")&&(sSubraza != "enano")&&(iBondad != ALIGNMENT_GOOD)) return TRUE;

    else return FALSE;
}
