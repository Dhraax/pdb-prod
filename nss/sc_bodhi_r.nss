int StartingConditional()
{
    object oPC = GetPCSpeaker();
    string sSubRace = GetStringLowerCase(GetSubRace(oPC));

    if (sSubRace == "vampiro" || sSubRace == "engendro") return TRUE;

    return FALSE;
}
