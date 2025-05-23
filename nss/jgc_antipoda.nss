int StartingConditional()
{
    object oPC= GetLastSpeaker();
    string sSubRaza = GetStringLowerCase(GetSubRace(oPC));
    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD) return FALSE;
    if(sSubRaza != "drow" && sSubRaza != "duergar" && sSubRaza != "svirfneblin" && sSubRaza != "orog") return FALSE;
    return TRUE;
}
