int StartingConditional()
{
    object oPC = GetPCSpeaker();
    string sSubraza = GetStringLowerCase(GetSubRace(oPC));
    string sAllowedSubRace = GetScriptParam("SUBRAZA");

    if(sSubraza == sAllowedSubRace) return TRUE;

    return FALSE;
}
