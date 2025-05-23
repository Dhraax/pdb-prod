int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nRace = GetRacialType(oPC);
    int nAllowedRace = StringToInt(GetScriptParam("RAZA"));

    if(nRace == nAllowedRace) return TRUE;

    return FALSE;
}
